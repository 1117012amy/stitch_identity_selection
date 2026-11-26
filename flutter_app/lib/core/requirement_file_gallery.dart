import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'customer_requirement.dart';

// ============================================================
// 客戶上傳檔案的共用元件：縮圖（含順序編號）＋ 點擊放大檢視。
// customer_signup_screen（上傳頁）與 view_orders_screen（委託詳情頁）共用，
// 兩邊看到的順序與數量完全一致。
// ============================================================

/// 單一縮圖：左上角顯示上傳順序（1、2、3…），PDF 顯示圖示與檔名。
class RequirementThumb extends StatelessWidget {
  const RequirementThumb({
    super.key,
    required this.file,
    required this.order,
    this.size = 76,
    this.selected = false,
    this.onTap,
    this.onRemove,
  });

  final RequirementFile file;

  /// 順序（從 1 開始）
  final int order;
  final double size;

  /// 是否為目前預覽中的那一張（用黃色粗框標示）
  final bool selected;
  final VoidCallback? onTap;

  /// 有給才會顯示右上角叉叉
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F1ED),
          border: Border.all(
            color: selected ? const Color(0xFF0055FF) : AppTheme.primary,
            width: selected ? 3 : AppStroke.regular,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (file.isPdf)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    size: 24,
                    color: AppTheme.accentRed,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            else
              Image.memory(
                file.bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            // 左上角：順序編號
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                color: const Color(0xFF0055FF),
                child: Text(
                  '$order',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (onRemove != null)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    color: AppTheme.primary,
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: AppTheme.paper,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 全螢幕檢視：左右滑動切換，頂部顯示「第幾張 / 共幾張」。
Future<void> showRequirementViewer(
  BuildContext context,
  List<RequirementFile> files,
  int initialIndex,
) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.92),
    builder: (_) =>
        _RequirementViewer(files: files, initialIndex: initialIndex),
  );
}

class _RequirementViewer extends StatefulWidget {
  const _RequirementViewer({required this.files, required this.initialIndex});

  final List<RequirementFile> files;
  final int initialIndex;

  @override
  State<_RequirementViewer> createState() => _RequirementViewerState();
}

class _RequirementViewerState extends State<_RequirementViewer> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int target) {
    if (target < 0 || target >= widget.files.length) {
      return;
    }
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.files.length;
    final file = widget.files[_index];
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            // 頂部：順序 / 總數 + 關閉
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    color: const Color(0xFF0055FF), // 藍色：與 project 頁的藍色相同
                    child: Text(
                      '${_index + 1} / $total',
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: total,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) {
                      final f = widget.files[i];
                      if (f.isPdf) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                size: 72,
                                color: AppTheme.accentRed,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                f.name,
                                style: const TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                f.sizeText,
                                style: const TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // 圖片：可雙指縮放
                      return InteractiveViewer(
                        child: Center(
                          child: Image.memory(f.bytes, fit: BoxFit.contain),
                        ),
                      );
                    },
                  ),
                  if (_index > 0)
                    Positioned(
                      left: 4,
                      child: IconButton(
                        onPressed: () => _go(_index - 1),
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (_index < total - 1)
                    Positioned(
                      right: 4,
                      child: IconButton(
                        onPressed: () => _go(_index + 1),
                        icon: const Icon(
                          Icons.chevron_right,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
