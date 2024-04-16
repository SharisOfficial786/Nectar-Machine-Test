import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/details/controllers/details_controller.dart';

class PdfView extends GetView<DetailsController> {
  const PdfView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: PDFView(
        filePath: controller.filePath,
        enableSwipe: true,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }
}
