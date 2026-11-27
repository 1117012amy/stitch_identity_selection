import 'package:flutter/material.dart';

import '../../core/app_icons.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

const double _loginInputHeight = 33;
const double _loginButtonHeight = 33;
const double _loginSocialHeight = 61;
const double _loginFrameWidth = 300;

class LoginVerificationScreen extends StatefulWidget {
  const LoginVerificationScreen({super.key});

  @override
  State<LoginVerificationScreen> createState() =>
      _LoginVerificationScreenState();
}

class _LoginVerificationScreenState extends State<LoginVerificationScreen> {
  final TextEditingController _passwordController = SpacedTextEditingController();
  int _passwordLength = 0;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _passwordLength = _passwordController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final frameWidth = constraints.maxWidth < _loginFrameWidth + 30
                ? constraints.maxWidth - 30
                : _loginFrameWidth;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: frameWidth,
                      padding: const EdgeInsets.all(14),
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
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 262),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SpacedText(
                                LoginText.title,
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontWeight: FontWeight.w900,
                                  fontSize: AppTypeScale.section,
                                  height: AppLineHeight.title,
                                  letterSpacing: AppTracking.none,
                                ),
                              ),
                              const SizedBox(height: AppSpace.md),
                              SpacedText(
                                LoginText.subtitle,
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontSize: AppTypeScale.micro,
                                  fontWeight: FontWeight.w700,
                                  height: AppLineHeight.snug,
                                  color: AppTheme.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                  letterSpacing: AppTracking.none,
                                ),
                              ),
                              const SizedBox(height: AppSpace.sectionGap),
                              const _FieldLabel(LoginText.mobileLabel),
                              const SizedBox(height: AppSpace.xs),
                              const _NeoLoginField(
                                keyboardType: TextInputType.phone,
                                hintText: '+886 0900 000 000',
                              ),
                              const SizedBox(height: AppSpace.base),
                              _LoginActionButton(
                                label: LoginText.sendOtp,
                                color: AppTheme.accentRed,
                                textColor: AppTheme.paper,
                                hasShadow: true,
                                onTap: () {},
                              ),
                              const SizedBox(height: AppSpace.base),
                              const _NeoLoginField(
                                keyboardType: TextInputType.number,
                                hintText: LoginText.otpHint,
                              ),
                              const SizedBox(height: AppSpace.base),
                              const Divider(
                                color: AppTheme.primary,
                                thickness: AppStroke.regular,
                              ),
                              const SizedBox(height: AppSpace.compact),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  const gap = AppSpace.md2;
                                  final socialSize =
                                      ((constraints.maxWidth - gap * 3) / 4)
                                          .clamp(0.0, _loginSocialHeight);

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildSocialIcon(
                                        AppIcons.google(size: 22),
                                        size: socialSize,
                                      ),
                                      const SizedBox(width: gap),
                                      _buildSocialIcon(
                                        AppIcons.apple(size: 22),
                                        size: socialSize,
                                      ),
                                      const SizedBox(width: gap),
                                      _buildSocialIcon(
                                        AppIcons.instagram(size: 22),
                                        size: socialSize,
                                      ),
                                      const SizedBox(width: gap),
                                      _buildSocialIcon(
                                        AppIcons.threads(size: 22),
                                        size: socialSize,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpace.base),
                              const Divider(
                                color: AppTheme.primary,
                                thickness: AppStroke.regular,
                              ),
                              const SizedBox(height: AppSpace.base),
                              const _FieldLabel(LoginText.emailLabel),
                              const SizedBox(height: AppSpace.sm),
                              const _NeoLoginField(
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'USER@OBSCURE.IO',
                              ),
                              const SizedBox(height: AppSpace.base),
                              const _FieldLabel(LoginText.passwordLabel),
                              const SizedBox(height: AppSpace.sm),
                              _NeoLoginField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !_isPasswordVisible,
                                hintText: LoginText.passwordHint,
                                suffixIcon: GestureDetector(
                                  onTap: () => setState(
                                    () => _isPasswordVisible =
                                        !_isPasswordVisible,
                                  ),
                                  child: Center(
                                    child: _isPasswordVisible
                                        ? AppIcons.eye(
                                            color: AppTheme.primary,
                                            size: 15,
                                          )
                                        : AppIcons.eyeOff(
                                            color: AppTheme.primary,
                                            size: 15,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpace.sm),
                              _buildStrengthMeter(),
                              const SizedBox(height: AppSpace.base),
                              _LoginActionButton(
                                label: LoginText.login,
                                color: AppTheme.primary,
                                textColor: AppTheme.paper,
                                hasShadow: true,
                                shadowColor: AppTheme.accentRed,
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/identity_selection',
                                ),
                              ),
                              const SizedBox(height: AppSpace.regular),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 12,
                                runSpacing: 6,
                                children: [
                                  const SpacedText(
                                    LoginText.forgotPassword,
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontSize: AppTypeScale.meta,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: AppStroke.regular,
                                      letterSpacing: AppTracking.none,
                                    ),
                                  ),
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Space Grotesk',
                                        fontSize: AppTypeScale.meta,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                        letterSpacing: AppTracking.none,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: LoginText.newUser,
                                          style: TextStyle(letterSpacing: kSmallChineseLetterSpacing),
                                        ),
                                        TextSpan(
                                          text: LoginText.requestAccess,
                                          style: TextStyle(
                                            color: AppTheme.accentBlue,
                                            letterSpacing: kSmallChineseLetterSpacing,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildSystemStatus(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialIcon(Widget icon, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.primary, width: AppStroke.regular),
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }

  Widget _buildSystemStatus() {
    return Container(
      width: _loginFrameWidth,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.accentRed,
        border: Border.all(color: AppTheme.primary, width: AppStroke.regular),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.primary,
            offset: AppTheme.hardShadowOffset,
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            color: AppTheme.paper,
            alignment: Alignment.center,
            child: const Icon(Icons.shield, color: AppTheme.primary, size: 15),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: SpacedText(
              LoginText.systemStatus,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: AppTypeScale.caption,
                height: AppLineHeight.readableTight,
                color: AppTheme.onRed,
                letterSpacing: AppTracking.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthMeter() {
    final length = _passwordLength;
    final strengthLevel = length < 6
        ? 1
        : length < 10
        ? 2
        : 3;
    final strengthText = strengthLevel == 1
        ? LoginText.weak
        : strengthLevel == 2
        ? LoginText.medium
        : LoginText.strong;
    final strengthColor = strengthLevel == 1
        ? AppTheme.accentRed
        : strengthLevel == 2
        ? AppTheme.accentYellow
        : AppTheme.accentBlue;

    return Row(
      children: [
        for (var index = 1; index <= 3; index++) ...[
          Expanded(
            child: Container(
              height: 3,
              color: strengthLevel >= index
                  ? strengthColor
                  : AppTheme.primary.withValues(alpha: 0.1),
            ),
          ),
          if (index < 3) const SizedBox(width: 4),
        ],
        const SizedBox(width: 8),
        SpacedText(
          strengthText,
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: AppTypeScale.micro,
            fontWeight: FontWeight.w700,
            height: AppLineHeight.snug,
            letterSpacing: AppTracking.none,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SpacedText(
      text,
      style: const TextStyle(
        fontFamily: 'Space Grotesk',
        fontSize: AppTypeScale.caption,
        fontWeight: FontWeight.w800,
        height: AppLineHeight.snug,
        letterSpacing: AppTracking.none,
      ),
    );
  }
}

class _NeoLoginField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  const _NeoLoginField({
    this.controller,
    this.keyboardType,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _loginInputHeight,
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.primary, width: AppStroke.regular),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: AppTypeScale.body,
          fontWeight: FontWeight.w700,
          height: AppLineHeight.snug,
          letterSpacing: AppTracking.none,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(letterSpacing: containsNonEnglish(hintText ?? '') ? kSmallChineseLetterSpacing : AppTracking.none,
            color: AppTheme.primary.withValues(alpha: 0.28),
            fontFamily: 'Space Grotesk',
            fontSize: AppTypeScale.caption,
            fontWeight: FontWeight.w700,
            height: AppLineHeight.snug,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : SizedBox(
                  width: 28,
                  height: _loginInputHeight,
                  child: suffixIcon,
                ),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _LoginActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color shadowColor;
  final bool hasShadow;
  final VoidCallback onTap;

  const _LoginActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.shadowColor = AppTheme.primary,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _loginButtonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppTheme.primary, width: AppStroke.regular),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: shadowColor,
                    offset: AppTheme.hardShadowOffset,
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: SpacedText(
          label,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: AppTypeScale.body,
            fontWeight: FontWeight.w900,
            height: AppLineHeight.snug,
            color: textColor,
            letterSpacing: AppTracking.none,
          ),
        ),
      ),
    );
  }
}
