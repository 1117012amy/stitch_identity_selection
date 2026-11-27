import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/app_text.dart';

class DesignerSignupScreen extends StatefulWidget {
  const DesignerSignupScreen({super.key});

  @override
  State<DesignerSignupScreen> createState() => _DesignerSignupScreenState();
}

class _DesignerSignupScreenState extends State<DesignerSignupScreen> {
  bool? _isMajor;
  double _workCount = 0;
  final TextEditingController _codeController = SpacedTextEditingController();
  final TextEditingController _nameController = SpacedTextEditingController();
  final TextEditingController _ageController = SpacedTextEditingController();
  final TextEditingController _phoneController = SpacedTextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const ObscureAppBar(
        leading: SizedBox.shrink(),
        actions: [SizedBox.shrink()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 7, height: 62, color: AppTheme.accentYellow),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpacedText(
                        DesignerSignupText.title,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 37,
                          height: 0.94,
                          letterSpacing: -1.2,
                        ),
                      ),
                      SizedBox(height: 7),
                      SpacedText(
                        DesignerSignupText.subtitle,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(20),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildUnderlineField(
                      DesignerSignupText.designerCode,
                      DesignerSignupText.designerCodeHint,
                      controller: _codeController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUnderlineField(
                            DesignerSignupText.name,
                            DesignerSignupText.realNameHint,
                            controller: _nameController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUnderlineField(
                            DesignerSignupText.age,
                            DesignerSignupText.ageHint,
                            controller: _ageController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildUnderlineField(
                      DesignerSignupText.phone,
                      DesignerSignupText.phoneHint,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 14),
                    const SpacedText(
                      DesignerSignupText.isDesignMajor,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildChoiceButton(
                            DesignerSignupText.yes,
                            _isMajor == true,
                            () => setState(() => _isMajor = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildChoiceButton(
                            DesignerSignupText.nonMajor,
                            _isMajor == false,
                            () => setState(() => _isMajor = false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const SpacedText(
                      DesignerSignupText.workCount,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentYellow,
                            border: Border.all(
                              color: AppTheme.primary,
                              width: AppStroke.regular,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SpacedText(
                            _workCount >= 10 ? '10+' : '${_workCount.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _workCount,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            activeColor: AppTheme.primary,
                            inactiveColor: AppTheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            onChanged: (val) =>
                                setState(() => _workCount = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final code = _codeController.text.trim();
                        await AppTheme.setRole(designer: true, nickname: code);
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pushReplacementNamed(
                          context,
                          '/designer_profile',
                          arguments: {
                            'name': code.isNotEmpty
                                ? code
                                : AppTheme.designerNickname,
                            'major': _isMajor == true
                                ? DesignerSignupText.designMajor
                                : null,
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.accentYellow,
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpacedText(
                              DesignerSignupText.start,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: AppTheme.primary,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlineField(
    String label,
    String hint, {
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacedText(
          label,
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 3),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(letterSpacing: containsNonEnglish(hint) ? kSmallChineseLetterSpacing : 0.0,
              color: AppTheme.primary.withValues(alpha: 0.3),
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primary,
                width: AppStroke.regular,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.accentBlue,
                width: AppStroke.regular,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            isDense: true,
          ),
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentBlue : AppTheme.paper,
          border: Border.all(color: AppTheme.primary, width: AppStroke.regular),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.primary,
              offset: AppTheme.hardShadowOffset,
              blurRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SpacedText(
          text,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w900,
            fontSize: 13,
            color: selected ? AppTheme.onBlue : AppTheme.primary,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
