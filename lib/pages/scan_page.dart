import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../providers/inference_provider.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  XFile? picked;
  bool running = false;

  Future<void> _pick(ImageSource src) async {
    final img = await ImagePicker().pickImage(
      source: src,
      maxWidth: 1024,
      imageQuality: 95,
    );
    if (!mounted) return;
    setState(() => picked = img);
  }

  Future<void> _analyze() async {
    if (picked == null || running) return;
    setState(() => running = true);
    try {
      final file = File(picked!.path);
      final result = await ref.read(inferControllerProvider).run(file);
      if (!mounted) return;
      context.go('/result', extra: result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Scan'),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          IconButton(
            tooltip: 'Home',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: picked == null
                          ? const Text('Pick an image to analyze')
                          : ClipRRect(
                        key: ValueKey(picked!.path),
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'picked-image',
                          child: Image.file(
                            File(picked!.path),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pick(ImageSource.gallery),
                        icon: const Icon(Icons.photo),
                        label: const Text('Gallery'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pick(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: picked == null || running ? null : _analyze,
                  icon: const Icon(Icons.pets),
                  label: Text(running ? 'Analyzing…' : 'Analyze'),
                ),
              ],
            ),
          ),
          if (running)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withOpacity(0.35),
                child: const Center(
                  child: SizedBox(
                    width: 56, height: 56,
                    child: CircularProgressIndicator(strokeWidth: 5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
