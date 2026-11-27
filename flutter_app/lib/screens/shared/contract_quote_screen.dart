import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

/// 頁面內容的最大寬度：網頁／平板上避免卡片被拉得過寬。
const double _kMaxContentWidth = 640;

/// 各區塊之間的統一間距（原本有 16 與 24 混用）。
const double _kSectionGap = 20;

class ContractQuoteScreen extends StatelessWidget {
  const ContractQuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const ObscureAppBar(),
      body: SafeArea(
        // Center + ConstrainedBox：窄螢幕照舊填滿，寬螢幕則置中並限制寬度
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 16, 15, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(),
                  const SizedBox(height: _kSectionGap),
                  _buildStatusCard(),
                  const SizedBox(height: _kSectionGap),
                  _buildTermsCard(),
                  const SizedBox(height: _kSectionGap),
                  _buildFeeCard(),
                  const SizedBox(height: _kSectionGap),
                  _buildSignatureCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── 各區塊 ─────────────────────────

  /// 頂部紅色標題區
  Widget _buildHero() {
    return const _NeoCard(
      color: AppTheme.accentRed,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedText(
            ContractQuoteText.title,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.03,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 12),
          SpacedText(
            ContractQuoteText.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Colors.white,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  /// 合約狀態與日期
  Widget _buildStatusCard() {
    return _NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacedText(
            ContractQuoteText.statusLabel,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SpacedText(
            ContractQuoteText.statusValue,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 29,
              fontWeight: FontWeight.w900,
              color: AppTheme.accentRed,
              letterSpacing: 0,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.primary, width: 1.5),
              ),
            ),
            child: const SpacedText(
              ContractQuoteText.date,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 合約條款：用迴圈取代原本手寫 [0]、[1]、[2]，條款數量改變時也不會漏掉
  Widget _buildTermsCard() {
    return _NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(ContractQuoteText.termsTitle),
          for (final term in ContractQuoteText.terms) ...[
            _buildTermItem(term.title, term.detail),
            // 最後一項後面不需要多餘的間距
            if (term != ContractQuoteText.terms.last)
              const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  /// 費用明細與總計
  Widget _buildFeeCard() {
    return _NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(ContractQuoteText.feeTitle),
          for (final fee in ContractQuoteText.fees) ...[
            _buildFeeItem(fee.title, fee.detail),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.primary,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SpacedText(
                    ContractQuoteText.total,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Flexible + 靠右：金額過長或字體放大時會換行而不是溢出
                Flexible(
                  child: SpacedText(
                    '\$ 14,700',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 簽名區（黃底）：簽名欄 + 同意聲明 + 兩顆按鈕
  Widget _buildSignatureCard() {
    return _NeoCard(
      color: AppTheme.accentYellow,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacedText(
                  ContractQuoteText.signature,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 80,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                    ),
                  ),
                  child: SpacedText(
                    ContractQuoteText.signatureHint,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      letterSpacing: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 同意聲明由 10 提高到 12，手機上較容易閱讀
                const SpacedText(
                  ContractQuoteText.consent,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          // 主要按鈕：深色底
          _ActionButton(
            label: ContractQuoteText.sign,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            onTap: () {}, // TODO: 之後接上實際簽署流程
          ),
          // 次要按鈕：透明底 + 上方分隔線
          _ActionButton(
            label: ContractQuoteText.downloadPdf,
            foregroundColor: AppTheme.primary,
            showTopBorder: true,
            onTap: () {}, // TODO: 之後接上 PDF 下載
          ),
        ],
      ),
    );
  }

  // ───────────────────────── 列表項目 ─────────────────────────

  Widget _buildTermItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue,
            border: Border.all(color: AppTheme.primary, width: 1.5),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacedText(
                title,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              SpacedText(
                description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeItem(String phase, String amount) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.primary, width: 1.5)),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SpacedText(
              phase,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 金額改用 Flexible：標題與金額都過長時不會擠出畫面
          Flexible(
            child: SpacedText(
              amount,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── 共用小元件 ─────────────────────────

/// 統一的「粗黑框 + 硬陰影」卡片，取代原本重複 5 次的 Container 裝飾。
/// 要改邊框、陰影或內距時，只需修改這一處。
class _NeoCard extends StatelessWidget {
  const _NeoCard({
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: child,
    );
  }
}

/// 卡片標題：文字下方一條分隔線，後面固定留 16 的間距。
class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.primary, width: 1.5)),
      ),
      child: SpacedText(
        text,
        style: const TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 17,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

/// 簽名區的整列按鈕。用 InkWell 取代 GestureDetector，點擊時會有水波紋回饋，
/// 並加上 Semantics 讓讀屏軟體知道這是按鈕。
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.foregroundColor,
    required this.onTap,
    this.backgroundColor,
    this.showTopBorder = false,
  });

  final String label;
  final Color foregroundColor;
  final Color? backgroundColor;
  final bool showTopBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        // Material 是水波紋的「畫布」，沒有它 InkWell 的回饋會被底色蓋住
        color: backgroundColor ?? Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            // 最小高度 56，符合手指點擊的建議大小
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            alignment: Alignment.center,
            decoration: showTopBorder
                ? const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.primary, width: 1.5),
                    ),
                  )
                : null,
            child: SpacedText(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: foregroundColor,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
