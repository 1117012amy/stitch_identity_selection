import 'package:flutter/material.dart';

import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import '../../core/neo_button.dart';

/// 客戶個人檔案頁。
///
/// 從客戶端底部導覽列的「個人」圖示進入（路由：/customer_profile）。
/// 版型沿用 designer_profile_screen.dart 的新粗獷風格：
/// 上方是暱稱＋頭像，中間是「自我介紹」卡片，下方是常用捷徑。
class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  // 暱稱與自我介紹的輸入控制器；初始值取自 AppTheme 的全域狀態
  late final TextEditingController _nameController;
  late final TextEditingController _introController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: AppTheme.customerNickname);
    _introController = TextEditingController(text: AppTheme.customerIntro);
  }

  @override
  void dispose() {
    // 控制器要手動釋放，避免記憶體殘留
    _nameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  /// 把輸入內容存回全域狀態，並用 SnackBar 提示。
  void _save() {
    final name = _nameController.text.trim();
    setState(() {
      // 暱稱不能是空白，空白時退回預設名稱
      AppTheme.customerNickname = name.isEmpty
          ? CustomerProfileText.defaultName
          : name;
      AppTheme.customerIntro = _introController.text.trim();
      _nameController.text = AppTheme.customerNickname;
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(CustomerProfileText.saved)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 頂部：暱稱＋標籤＋頭像 ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTheme.customerNickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            height: 0.98,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const _ProfileTag(CustomerProfileText.tag),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.paper,
                      border: Border.all(
                        color: AppTheme.primary,
                        width: AppStroke.regular,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.primary,
                          offset: AppTheme.hardShadowOffset,
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person_outline,
                      size: 36,
                      color: AppTheme.primary.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── 中間：暱稱與自我介紹編輯卡片 ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.paper,
                  border: Border.all(
                    color: AppTheme.primary,
                    width: AppStroke.regular,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.primary,
                      offset: AppTheme.hardShadowOffset,
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _FieldLabel(CustomerProfileText.fieldName),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _nameController,
                      maxLength: 20,
                      style: _fieldTextStyle,
                      decoration: _underlineDecoration(
                        CustomerProfileText.nameHint,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _FieldLabel(CustomerProfileText.introTitle),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _introController,
                      minLines: 4,
                      maxLines: 8,
                      maxLength: 300,
                      style: _fieldTextStyle,
                      decoration: _underlineDecoration(
                        CustomerProfileText.introHint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              NeoButton(
                onTap: _save,
                color: AppTheme.accentYellow,
                depth: 3,
                borderWidth: AppStroke.regular,
                child: const _ProfileActionLabel(CustomerProfileText.save),
              ),
              const SizedBox(height: 10),

              // ── 下方：常用捷徑 ──
              Row(
                children: [
                  Expanded(
                    child: NeoButton(
                      onTap: () => Navigator.pushNamed(context, '/project'),
                      color: AppTheme.primary,
                      shadowColor: AppTheme.accentBlue,
                      depth: 3,
                      borderWidth: AppStroke.regular,
                      child: const _ProfileActionLabel(
                        CustomerProfileText.myCommissions,
                        color: AppTheme.paper,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NeoButton(
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                      depth: 3,
                      borderWidth: AppStroke.regular,
                      child: const _ProfileActionLabel(
                        CustomerProfileText.settings,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // 底部導覽列：目前停在「個人」圖示
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/customer_profile',
      ),
    );
  }
}

// 輸入框共用的文字樣式與底線樣式（與客戶註冊頁一致）
const TextStyle _fieldTextStyle = TextStyle(
  fontSize: 12,
  fontFamily: 'Space Grotesk',
  letterSpacing: 0,
);

InputDecoration _underlineDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: AppTheme.primary.withValues(alpha: 0.3),
      fontSize: 12,
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.primary,
        width: AppStroke.hairline,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.accentRed,
        width: AppStroke.regular,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 6),
    isDense: true,
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Space Grotesk',
        fontWeight: FontWeight.bold,
        fontSize: 11,
        letterSpacing: 0,
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  final String text;

  const _ProfileTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.paper,
          border: Border.all(color: AppTheme.primary, width: AppStroke.regular),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _ProfileActionLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _ProfileActionLabel(this.text, {this.color = AppTheme.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10.5),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w900,
          fontSize: 14,
          height: 1,
          color: color,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
