// lib/services/inference.dart
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;

class Prediction {
  final String label;
  final double score;
  Prediction(this.label, this.score);
}

class InferenceResult {
  final List<Prediction> top; // sorted desc
  Prediction get best => top.first;
  InferenceResult(this.top);
}

class InferenceEngine {
  tfl.Interpreter? _interpreter;
  late List<String> _labels;

  // crude animal keyword filter (covers mammals, birds, fish, reptiles, insects)
  static const _animalKeys = [
    'dog','cat','bird','owl','eagle','hawk','falcon','parrot','finch','pigeon','duck','goose','swan',
    'chicken','hen','rooster','cock','turkey','quail','ostrich','emu','kiwi',
    'fish','shark','ray','salmon','trout','pike','carp','goldfish','tuna','mackerel',
    'whale','dolphin','seal','sea_lion','walrus',
    'bear','wolf','fox','hyena','lion','tiger','leopard','jaguar','cheetah','cougar','lynx','bobcat',
    'elephant','rhino','hippopotamus','giraffe','zebra','horse','donkey','cow','bull','bison','buffalo','yak',
    'sheep','goat','pig','boar','hog',
    'deer','moose','elk','reindeer','antelope','gazelle',
    'rabbit','hare','squirrel','chipmunk','beaver','otter','raccoon','badger','skunk','mole','shrew','armadillo',
    'monkey','ape','gorilla','chimpanzee','orangutan','baboon','lemur',
    'bat','kangaroo','koala','panda','sloth','hedgehog','porcupine',
    'snake','python','cobra','viper','rattlesnake','boa','anaconda',
    'lizard','gecko','iguana','chameleon','monitor',
    'crocodile','alligator','caiman','tortoise','turtle','terrapin',
    'frog','toad','salamander','newt',
    'insect','butterfly','moth','bee','wasp','hornet','ant','termite','beetle','fly','mosquito','dragonfly','grasshopper','cricket',
    'spider','scorpion','centipede','millipede',
    'crab','lobster','shrimp','prawn','squid','octopus','jellyfish','starfish','coral'
  ];

  Future<void> _ensureLoaded() async {
    if (_interpreter != null) return;

    final rawModel = await rootBundle.load('assets/models/2.tflite');
    _interpreter = tfl.Interpreter.fromBuffer(rawModel.buffer.asUint8List());

    final labelsStr = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsStr.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    _interpreter!.allocateTensors();
  }

  Future<InferenceResult> classify(File imageFile) async {
    await _ensureLoaded();

    // Decode
    final decoded = img.decodeImage(await imageFile.readAsBytes());
    if (decoded == null) {
      throw Exception('Could not decode image');
    }

    // Input tensor H/W
    final inTensor = _interpreter!.getInputTensor(0);
    final inShape = inTensor.shape; // [1, H, W, 3]
    if (inShape.length != 4 || inShape[3] != 3) {
      throw Exception('Unexpected input shape: $inShape');
    }
    final h = inShape[1], w = inShape[2];

    // Resize + normalize
    final resized = img.copyResize(decoded, width: w, height: h, interpolation: img.Interpolation.linear);
    final floatData = List<double>.filled(h * w * 3, 0.0);
    int j = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final p = resized.getPixel(x, y);
        floatData[j++] = p.r / 255.0;
        floatData[j++] = p.g / 255.0;
        floatData[j++] = p.b / 255.0;
      }
    }

    // Build nested input [1,H,W,3]
    final input4d = List.generate(
      1,
          (_) => List.generate(
        h,
            (yy) => List.generate(
          w,
              (xx) {
            final base = (yy * w + xx) * 3;
            return <double>[
              floatData[base + 0],
              floatData[base + 1],
              floatData[base + 2],
            ];
          },
        ),
      ),
    );

    // Output [1,N]
    final outTensor = _interpreter!.getOutputTensor(0);
    final n = outTensor.shape.last;
    final output2d = List.generate(1, (_) => List.filled(n, 0.0));

    // Inference
    _interpreter!.run(input4d, output2d);
    final probs = output2d[0];

    // Top-5 indices by score
    final idxs = List<int>.generate(probs.length, (i) => i);
    idxs.sort((a, b) => probs[b].compareTo(probs[a]));
    final topK = idxs.take(5).map((i) {
      final lbl = (i < _labels.length) ? _labels[i] : 'Class $i';
      return Prediction(lbl, probs[i]);
    }).toList();

    // Filter to animal-like labels (fallback to generic if none)
    bool isAnimal(String s) {
      final t = s.toLowerCase().replaceAll('_', ' ');
      return _animalKeys.any((k) => t.contains(k));
    }
    final animalTop = topK.where((p) => isAnimal(p.label)).toList();
    final finalTop = animalTop.isNotEmpty ? animalTop : topK;

    return InferenceResult(finalTop);
  }
}
