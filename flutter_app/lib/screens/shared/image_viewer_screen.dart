import 'dart:typed_data';
import 'package:flutter/material.dart';

/// 全螢幕圖片檢視頁：點擊聊天室圖片後開啟。
/// 支援：雙指縮放、拖曳平移、雙擊放大／還原、點背景或右上角 X 關閉。
class ImageViewerScreen extends StatefulWidget {
  final Uint8List bytes; // 原始圖片資料（不經裁切，顯示完整原圖）
  final String fileName; // 顯示在上方的檔名
  final Object heroTag; // 與聊天室縮圖配對的 Hero 動畫標籤

  const ImageViewerScreen({
    super.key,
    required this.bytes,
    required this.fileName,
    required this.heroTag,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with SingleTickerProviderStateMixin {
  // 控制縮放／平移的矩陣控制器
  final TransformationController _controller = TransformationController();
  late final AnimationController _animController;
  Animation<Matrix4>? _animation;

  // 記錄雙擊的位置，用來以該點為中心放大
  Offset _doubleTapPosition = Offset.zero;

  static const double _doubleTapScale = 2.5; // 雙擊放大倍率

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220),
        )..addListener(() {
          // 動畫進行時，持續更新圖片的變形矩陣
          final anim = _animation;
          if (anim != null) _controller.value = anim.value;
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// 雙擊：目前是原始大小就放大到指定倍率，已放大則還原
  void _handleDoubleTap() {
    final bool isZoomed = _controller.value.getMaxScaleOnAxis() > 1.01;
    final Matrix4 end;
    if (isZoomed) {
      end = Matrix4.identity();
    } else {
      final p = _doubleTapPosition;
      // 以點擊位置為中心放大：先位移到點擊點，縮放後再位移回來
      end = Matrix4.identity()
        ..translateByDouble(
          -p.dx * (_doubleTapScale - 1),
          -p.dy * (_doubleTapScale - 1),
          0,
          1,
        )
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, _doubleTapScale, 1);
    }
    _animation = Matrix4Tween(
      begin: _controller.value,
      end: end,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 圖片區：GestureDetector 負責雙擊，InteractiveViewer 負責縮放與拖曳
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTapDown: (d) => _doubleTapPosition = d.localPosition,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _controller,
                minScale: 1.0,
                maxScale: 6.0,
                child: Center(
                  child: Hero(
                    tag: widget.heroTag,
                    child: Image.memory(
                      widget.bytes,
                      fit: BoxFit.contain, // 完整顯示原圖，不裁切
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 頂部列：關閉按鈕與檔名
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: '關閉',
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        widget.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
