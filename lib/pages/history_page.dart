import 'dart:io';
import 'package:flutter/material.dart';
import '../stores/history_store.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}


class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final items = HistoryStore.items;
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: items.isEmpty
          ? const Center(child: Text('No scans yet'))
          : ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final it = items[i];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(File(it.imagePath), width: 56, height: 56, fit: BoxFit.cover),
            ),
            title: Text(it.label),
            subtitle: Text('${(it.confidence * 100).toStringAsFixed(1)}% • ${it.when}'),
          );
        },
      ),
    );
  }
}