import 'package:hive_flutter/hive_flutter.dart';


class ScanItem {
  final String label;
  final double confidence;
  final String imagePath;
  final DateTime when;
  ScanItem({required this.label, required this.confidence, required this.imagePath, required this.when});
}


class HistoryStore {
  static late Box _box;
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('history');
  }


  static List<ScanItem> get items {
    final list = <ScanItem>[];
    for (final m in _box.values) {
      list.add(ScanItem(
        label: m['label'],
        confidence: (m['confidence'] as num).toDouble(),
        imagePath: m['imagePath'],
        when: DateTime.parse(m['when']),
      ));
    }
    list.sort((a, b) => b.when.compareTo(a.when));
    return list;
  }


  static Future<void> addItem({required String label, required double confidence, required String imagePath}) async {
    await _box.add({
      'label': label,
      'confidence': confidence,
      'imagePath': imagePath,
      'when': DateTime.now().toIso8601String(),
    });
  }
}