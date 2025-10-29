import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../utils/pdf_report.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> map;
  const ResultPage({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    final when = DateFormat.yMMMd().add_jm().format(DateTime.now());
    final bestLabel = map['label'] as String;
    final bestConf = (map['confidence'] as num).toDouble();
    final imagePath = map['imagePath'] as String? ?? '';
    final List<dynamic>? top = map['top'] as List<dynamic>?; // [{label, score}, ...]

    Color riskColor(double c) {
      if (c >= 0.85) return Colors.green;
      if (c >= 0.6) return Colors.teal;
      return Colors.blueGrey;
    }

    final file = File(imagePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('animallens Result'),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          IconButton(
            tooltip: 'Home',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: 'picked-image',
              child: file.existsSync()
                  ? Image.file(file, fit: BoxFit.contain)
                  : const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_not_supported, size: 120, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('No image file found', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(color: riskColor(bestConf), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      bestLabel.replaceAll('_', ' '),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('${(bestConf * 100).toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
          if (top != null && top.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Top predictions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...top.map((e) {
              final lbl = (e['label'] as String).replaceAll('_', ' ');
              final sc = (e['score'] as num).toDouble();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lbl),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: sc.clamp(0.0, 1.0),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('${(sc * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => PdfReport.share(map),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Export PDF'),
          ),
          const SizedBox(height: 8),
          Text('Analyzed: $when', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
