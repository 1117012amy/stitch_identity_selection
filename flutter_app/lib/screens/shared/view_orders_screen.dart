import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/customer_requirement.dart';

// ============================================================
// ViewOrdersScreen：客戶委託詳情頁（COMMISSION DETAIL）
// 來源：View Orders/code.html
// 從「委託」頁（ProjectScreen）點任何一張委託卡片進來。
// 頂部列 / 底部導覽列、框線粗細、硬陰影、色塊間距，
// 全部和 project_screen.dart 使用同一套設定。
// 稱呼 / 電話 / 需求文字 / 圖片 / PDF 讀取客戶在需求上傳介面
// （customer_signup_screen）填的資料；客戶沒填時顯示範例內容。
// ============================================================

/// 色票：與 project_screen.dart 相同
class _C {
  static const Color ink = AppTheme.primary;
  static const Color yellow = AppTheme.accentYellow;
  static const Color red = Color(0xFFFF3F3F);
  static const Color blue = Color(0xFF0055FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey100 = Color(0xFFF5F5F5);
}

// 範例內容（客戶尚未填寫時使用）
const String _sampleName = '鮭魚創意實業';
const String _sampleRole = 'ALEX CHEN 總監';
const String _samplePhone = '+886 0912 345 678';
const String _sampleBrief =
    '我們正在籌備 2025 年春季有機烘焙品牌『原穀酵母』全套包裝與快閃店主視覺。'
    '期望整體調性融合包浩斯排版韻律感與當代粗獷幾何，傳遞職人手工精神與純淨無添加理念。';

/// 標題字樣式：與 project_screen.dart 的 _head 相同
TextStyle _head(
  double size, {
  Color color = _C.ink,
  FontWeight weight = FontWeight.w900,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: 'Space Grotesk',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// 粗黑框 + 無模糊硬陰影：與 project_screen.dart 的 _NeoBox 相同
class _NeoBox extends StatelessWidget {
  const _NeoBox({
    required this.color,
    required this.child,
    this.shadowColor = _C.ink,
    this.padding = EdgeInsets.zero,
  });

  final Color color;
  final Widget child;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: _C.ink, width: AppStroke.regular),
        boxShadow: [
          BoxShadow(color: shadowColor, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: child,
    );
  }
}

class ViewOrdersScreen extends StatelessWidget {
  const ViewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final req = CustomerRequirementStore.current;
    // 有填的欄位用客戶資料，沒填的用範例
    final hasName = req.name.trim().isNotEmpty;
    final name = hasName ? req.name.trim() : _sampleName;
    final phone = req.phone.trim().isEmpty ? _samplePhone : req.phone.trim();
    final brief = req.description.trim().isEmpty
        ? _sampleBrief
        : req.description.trim();

    return Scaffold(
      backgroundColor: AppTheme.background,
      // 最上排：與 project 頁相同的共用頂部列
      appBar: ObscureAppBar(
        // 返回鍵：位置與聊天室相同（左邊 12 + 44 寬按鈕，圖示 22）
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back, size: 22, color: _C.ink),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // 內距、區塊間距與 project 頁一致（左右 12、區塊間 12 / 16）
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _clientCard(name, hasName ? '客戶' : _sampleRole),
              const SizedBox(height: 12),
              _phoneCard(phone),
              const SizedBox(height: 12),
              _briefCard(brief),
              if (req.hasFile && !req.isPdf) ...[
                const SizedBox(height: 12),
                _imageCard(req),
              ],
              const SizedBox(height: 12),
              if (req.hasFile && req.isPdf)
                _pdfCard(req.fileName!, req.fileSizeText)
              else if (!req.hasFile)
                _pdfCard('品牌視覺調性參考指南_2024.pdf', null),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. CLIENT DOSSIER：稱呼（紅色卡 + 黃色硬陰影）
  Widget _clientCard(String name, String role) {
    return _NeoBox(
      color: _C.red,
      shadowColor: _C.yellow,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _C.white,
                  border: Border.all(color: _C.ink, width: AppStroke.regular),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'CLIENT DOSSIER',
                style: _head(10, color: _C.white, letterSpacing: 1),
              ),
              const Spacer(),
              Container(
                color: _C.ink,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text('VERIFIED', style: _head(9, color: _C.yellow)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(name, style: _head(24, color: _C.white, height: 1.1)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _C.ink,
              border: Border.all(color: _C.white, width: AppStroke.regular),
            ),
            child: Text(role, style: _head(12, color: _C.white)),
          ),
        ],
      ),
    );
  }

  /// 2. DIRECT LINE：電話（黑色卡 + 紅色硬陰影）
  Widget _phoneCard(String phone) {
    return _NeoBox(
      color: _C.ink,
      shadowColor: _C.red,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _NeoBox(
            color: _C.white,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.phone, size: 20, color: _C.ink),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DIRECT LINE',
                  style: _head(9, color: _C.yellow, letterSpacing: 1),
                ),
                const SizedBox(height: 2),
                SelectableText(
                  phone,
                  style: _head(18, color: _C.white, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. COMMISSION BRIEF：需求文字（白色卡）
  Widget _briefCard(String brief) {
    return _NeoBox(
      color: _C.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _C.ink, width: AppStroke.regular),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _C.red,
                    border: Border.all(color: _C.ink, width: AppStroke.thin),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'COMMISSION BRIEF / 委託需求',
                    style: _head(11, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(brief, style: _head(13, weight: FontWeight.w700, height: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: _C.ink, width: AppStroke.regular),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROJECT CODE: #2025-BRUTAL',
                  style: _head(8, color: _C.grey500, weight: FontWeight.w700),
                ),
                Row(
                  children: [
                    for (final c in [_C.ink, _C.red, _C.blue])
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: c,
                          border: Border.all(
                            color: _C.ink,
                            width: AppStroke.thin,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4A. VISUAL REF：客戶上傳的圖片
  Widget _imageCard(CustomerRequirement req) {
    return _NeoBox(
      color: _C.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 黑色標題條：與 project 卡片的標題條相同
          Container(
            color: _C.ink,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('VISUAL REF 01 / 意象提案',
                    style: _head(10, color: _C.yellow)),
                Text('FIG. A', style: _head(10, color: _C.white)),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: _C.grey100,
              border: Border(
                bottom: BorderSide(color: _C.ink, width: AppStroke.regular),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.memory(
              req.fileBytes!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 200,
                child: Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'MOODBOARD SAMPLE',
              style: _head(9, color: _C.grey500, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  /// 4B. ATTACHED FILE：PDF 檔名
  Widget _pdfCard(String fileName, String? sizeText) {
    return _NeoBox(
      color: _C.white,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _NeoBox(
            color: _C.red,
            child: SizedBox(
              width: 44,
              height: 52,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined,
                      size: 22, color: _C.white),
                  Text('PDF', style: _head(9, color: _C.white)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ATTACHED FILE',
                  style: _head(9, color: _C.red, letterSpacing: 1),
                ),
                const SizedBox(height: 2),
                Text(fileName, style: _head(12, height: 1.3)),
                if (sizeText != null)
                  Text(
                    sizeText,
                    style: _head(9, color: _C.grey500, weight: FontWeight.w700),
                  ),
              ],
            ),
          ),
          const Icon(Icons.attach_file, size: 20, color: _C.ink),
        ],
      ),
    );
  }
}
