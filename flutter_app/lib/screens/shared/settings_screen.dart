import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        toolbarHeight: AppTheme.appBarHeight,
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primary,
              size: 22,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        title: const Text(
          SettingsText.title,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w900,
            fontSize: AppTypeScale.buttonLarge,
            height: AppLineHeight.title,
            color: AppTheme.primary,
            letterSpacing: AppTracking.none,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppTheme.appBarDividerHeight),
          child: Container(
            color: AppTheme.primary,
            height: AppTheme.appBarDividerHeight,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.pageX,
            AppTypeScale.pageTitleSmall,
            AppSpace.pageX,
            AppSpace.pageY,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProfileCard(),
              const SizedBox(height: AppSpace.xxl),
              _SettingsSection(
                title: SettingsText.sectionAccount,
                color: AppTheme.accentBlue,
                children: [
                  _ActionRow(
                    icon: Icons.person_outline,
                    iconColor: AppTheme.accentBlue,
                    label: SettingsText.editProfile,
                    onTap: () {},
                  ),
                  _ActionRow(
                    icon: Icons.security,
                    iconColor: AppTheme.accentRed,
                    label: SettingsText.security,
                    onTap: () {},
                  ),
                  _ActionRow(
                    icon: Icons.card_membership,
                    iconColor: AppTheme.accentYellow,
                    label: SettingsText.membership,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionWorkMode,
                color: AppTheme.accentYellow,
                children: [
                  _ValueRow(
                    icon: Icons.swap_horiz,
                    label: SettingsText.roleSwitch,
                    value: SettingsText.roleDesigner,
                    valueColor: AppTheme.accentBlue,
                  ),
                  _ToggleRow(
                    icon: Icons.work_outline,
                    label: SettingsText.acceptJobs,
                    isEnabled: true,
                  ),
                  _ActionRow(
                    icon: Icons.schedule,
                    iconColor: AppTheme.accentRed,
                    label: SettingsText.availableTime,
                  ),
                  _ActionRow(
                    icon: Icons.category_outlined,
                    iconColor: AppTheme.accentBlue,
                    label: SettingsText.categories,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionNotifications,
                color: AppTheme.accentRed,
                children: [
                  _ToggleRow(
                    icon: Icons.notifications_none,
                    label: SettingsText.push,
                    isEnabled: true,
                  ),
                  _ToggleRow(
                    icon: Icons.mail_outline,
                    label: SettingsText.emailNotify,
                    isEnabled: false,
                  ),
                  _ToggleRow(
                    icon: Icons.chat_bubble_outline,
                    label: SettingsText.messageNotify,
                    isEnabled: true,
                  ),
                  _ToggleRow(
                    icon: Icons.payments_outlined,
                    label: SettingsText.paymentNotify,
                    isEnabled: true,
                  ),
                  _ToggleRow(
                    icon: Icons.assignment_outlined,
                    label: SettingsText.contractNotify,
                    isEnabled: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionPayment,
                color: AppTheme.accentBlue,
                children: [
                  _ActionRow(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppTheme.accentBlue,
                    label: SettingsText.wallet,
                  ),
                  _ActionRow(
                    icon: Icons.request_quote_outlined,
                    iconColor: AppTheme.accentRed,
                    label: SettingsText.quotes,
                  ),
                  _ActionRow(
                    icon: Icons.receipt_long,
                    iconColor: AppTheme.accentYellow,
                    label: SettingsText.invoices,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionAppearance,
                color: AppTheme.accentYellow,
                children: [
                  _ValueRow(
                    icon: Icons.language,
                    label: SettingsText.language,
                    value: SettingsText.languageValue,
                    valueColor: AppTheme.accentBlue,
                  ),
                  _ValueRow(
                    icon: Icons.palette_outlined,
                    label: SettingsText.themeStyle,
                    value: 'BAUHAUS',
                    valueColor: AppTheme.accentRed,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionPrivacy,
                color: AppTheme.accentRed,
                children: [
                  _ToggleRow(
                    icon: Icons.visibility_outlined,
                    label: SettingsText.profileVisibility,
                    isEnabled: true,
                  ),
                  _ToggleRow(
                    icon: Icons.bar_chart,
                    label: SettingsText.analytics,
                    isEnabled: true,
                  ),
                  _ActionRow(
                    icon: Icons.block,
                    iconColor: AppTheme.accentRed,
                    label: SettingsText.blocked,
                  ),
                  _ActionRow(
                    icon: Icons.file_download_outlined,
                    iconColor: AppTheme.accentBlue,
                    label: SettingsText.exportData,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionSupport,
                color: AppTheme.accentBlue,
                children: [
                  _ActionRow(
                    icon: Icons.bug_report_outlined,
                    iconColor: AppTheme.accentRed,
                    label: SettingsText.reportBug,
                  ),
                  _ActionRow(
                    icon: Icons.new_releases_outlined,
                    iconColor: AppTheme.accentYellow,
                    label: SettingsText.releaseNotes,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.xxl),
              const _SettingsSection(
                title: SettingsText.sectionAbout,
                color: AppTheme.primary,
                children: [
                  _ActionRow(
                    label: SettingsText.terms,
                    trailingIcon: Icons.open_in_new,
                  ),
                  _ActionRow(
                    label: SettingsText.privacyPolicy,
                    trailingIcon: Icons.description,
                  ),
                  _ActionRow(
                    label: SettingsText.aboutObscure,
                    trailingIcon: Icons.info_outline,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.heroGap),
              const _LogoutButton(),
              const SizedBox(height: AppSpace.sectionGap),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.paper,
        border: Border.fromBorderSide(
          BorderSide(color: AppTheme.primary, width: AppStroke.heavy),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentYellow,
            offset: AppTheme.hardShadowOffset,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.large,
        AppSpace.xl,
        AppSpace.large,
        AppSpace.xl,
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.paper,
                  border: Border.all(
                    color: AppTheme.primary,
                    width: AppStroke.heavy,
                  ),
                ),
                child: const _AvatarMark(),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow,
                    border: Border.all(
                      color: AppTheme.primary,
                      width: AppStroke.heavy,
                    ),
                  ),
                  child: const Icon(Icons.edit, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.regularPlus),
          const Text(
            SettingsText.profileName,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              fontSize: AppTypeScale.display,
              height: AppLineHeight.tight,
              color: AppTheme.accentRed,
              letterSpacing: AppTracking.none,
            ),
          ),
          const SizedBox(height: AppSpace.base),
          const Text(
            SettingsText.email,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w800,
              fontSize: AppTypeScale.label,
              color: AppTheme.primary,
              letterSpacing: AppTracking.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarMark extends StatelessWidget {
  const _AvatarMark();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: AppTheme.canvas)),
          Positioned(
            left: 22,
            top: 22,
            child: Container(
              width: 30,
              height: 48,
              color: AppTheme.accentYellow,
            ),
          ),
          Positioned(
            right: 20,
            top: 24,
            child: Container(width: 28, height: 42, color: AppTheme.accentRed),
          ),
          Positioned(
            left: 34,
            top: 12,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 28,
            child: Container(width: 14, height: 14, color: AppTheme.accentBlue),
          ),
          Positioned(
            left: 26,
            bottom: 22,
            child: Container(width: 44, height: 2, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(width: 10, height: 28, color: color),
            const SizedBox(width: AppSpace.compact),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: AppTypeScale.buttonLarge,
                color: AppTheme.primary,
                letterSpacing: AppTracking.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.cardGap),
        ...children.expand(
          (child) => [child, const SizedBox(height: AppSpace.sectionGap)],
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;
  final String label;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  const _ActionRow({
    this.icon,
    this.iconColor = AppTheme.primary,
    required this.label,
    this.trailingIcon = Icons.chevron_right,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingFrame(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: AppSpace.cardGap),
          ],
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: AppTypeScale.label,
                color: AppTheme.primary,
                letterSpacing: AppTracking.none,
              ),
            ),
          ),
          Icon(trailingIcon, color: AppTheme.primary, size: 22),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _ValueRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingFrame(
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 18),
          const SizedBox(width: AppSpace.cardGap),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: AppTypeScale.label,
                letterSpacing: AppTracking.none,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              fontSize: AppTypeScale.label,
              color: valueColor,
              letterSpacing: AppTracking.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.isEnabled,
  });

  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  late bool _isEnabled;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.isEnabled;
  }

  void _toggle() {
    setState(() {
      _isEnabled = !_isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        offset: _isPressed ? const Offset(0.01, 0.04) : Offset.zero,
        child: _SettingFrame(
          onTap: _toggle,
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: AppTheme.primary),
              const SizedBox(width: AppSpace.cardGap),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w900,
                    fontSize: AppTypeScale.label,
                    letterSpacing: AppTracking.none,
                  ),
                ),
              ),
              _NeoToggle(isEnabled: _isEnabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeoToggle extends StatelessWidget {
  final bool isEnabled;

  const _NeoToggle({required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOutCubic,
      width: 50,
      height: 28,
      decoration: BoxDecoration(
        color: isEnabled ? AppTheme.accentYellow : AppTheme.primary,
        border: Border.all(color: AppTheme.primary, width: AppStroke.heavy),
      ),
      padding: const EdgeInsets.all(3),
      alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutCubic,
        width: 20,
        height: 20,
        color: AppTheme.paper,
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: AppTheme.primary, width: AppStroke.heavy),
        ),
      ),
    );
  }
}

class _SettingFrame extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _SettingFrame({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final frame = Container(
      decoration: const BoxDecoration(
        color: AppTheme.paper,
        border: Border.fromBorderSide(
          BorderSide(color: AppTheme.primary, width: AppStroke.heavy),
        ),
        boxShadow: [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.regular,
        vertical: AppSpace.cardGap,
      ),
      child: child,
    );

    if (onTap == null) return frame;
    return GestureDetector(onTap: onTap, child: frame);
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.accentRed,
        border: Border.fromBorderSide(
          BorderSide(color: AppTheme.primary, width: AppStroke.heavy),
        ),
        boxShadow: [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      height: 72,
      alignment: Alignment.center,
      child: const Text(
        SettingsText.logout,
        style: TextStyle(
          color: AppTheme.paper,
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w900,
          fontSize: AppTypeScale.titleLarge,
          letterSpacing: AppTracking.wider,
        ),
      ),
    );
  }
}
