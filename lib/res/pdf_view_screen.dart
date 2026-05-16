import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String url;

  const PdfViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextConst(title: "PDF View",color: AppColor.white,size: 17,),
        backgroundColor: AppColor.royalBlue,
        foregroundColor: Colors.white,
      ),
      body: SfPdfViewer.network(url),
    );
  }
}