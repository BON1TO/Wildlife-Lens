// lib/providers/inference_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/inference.dart';
import '../stores/history_store.dart';

final inferControllerProvider = Provider((ref) => InferController());

class InferController {
  final _engine = InferenceEngine();

  Future<Map<String, dynamic>> run(File image) async {
    final res = await _engine.classify(image); // res.best + res.top

    // Save top-1 to history
    await HistoryStore.addItem(
      label: res.best.label,
      confidence: res.best.score,
      imagePath: image.path,
    );

    // Return payload used by ResultPage
    return {
      'label': res.best.label,
      'confidence': res.best.score,
      'imagePath': image.path,
      'top': res.top
          .map((p) => {'label': p.label, 'score': p.score})
          .toList(),
    };
  }
}
