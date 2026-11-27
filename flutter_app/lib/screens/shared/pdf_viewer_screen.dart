import '../../core/spaced_text.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// 全螢幕 PDF 檢視頁：點擊聊天室的 PDF 檔案後開啟。
/// pdfrx 內建：雙指縮放、拖曳、雙擊放大、捲動翻頁。
class PdfViewerScreen extends StatelessWidget {
  final Uint8List bytes; // PDF 檔案內容（記憶體中的資料）
  final String fileName; // 顯示在上方的檔名

  const PdfViewerScreen({
    super.key,
    required this.bytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: SpacedText(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: PdfViewer.data(
        bytes,
        sourceName: fileName, // pdfrx 用來辨識文件的名稱
      ),
    );
  }
}
