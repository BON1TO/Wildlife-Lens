import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReport {
  static Future<void> share(Map<String, dynamic> res) async {
    final doc = pw.Document();

    // Read file to bytes, then wrap in MemoryImage
    final bytes = await File(res['imagePath']).readAsBytes();
    final image = pw.MemoryImage(bytes);

    doc.addPage(
      pw.Page(
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('MediLens Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Diagnosis: ${res['label']}'),
            pw.Text('Confidence: ${(res['confidence'] * 100).toStringAsFixed(1)}%'),
            pw.SizedBox(height: 12),
            pw.ClipRRect(child: pw.Image(image)),
            pw.SizedBox(height: 12),
            pw.Text('Generated offline on device.'),
          ],
        ),
      ),
    );

    final pdfBytes = await doc.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: 'medilens_report.pdf');
  }
}
