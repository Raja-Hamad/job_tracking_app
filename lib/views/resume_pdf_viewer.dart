import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResumePdfViewer extends StatelessWidget {
  final String pdfUrl;

  const ResumePdfViewer({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Viewer'),
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
