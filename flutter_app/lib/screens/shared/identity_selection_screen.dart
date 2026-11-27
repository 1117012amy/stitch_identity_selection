import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/app_text.dart';
import '../../core/neo_button.dart';

class IdentitySelectionScreen extends StatelessWidget {
  const IdentitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ObscureAppBar(
        leading: SizedBox.shrink(),
        actions: [SizedBox.shrink()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildIdentityCard(
                  context,
                  title: IdentityText.designerTitle,
                  description: IdentityText.designerDescription,
                  actionText: IdentityText.designerAction,
                  icon: Icons.architecture,
                  bgColor: const Color(0xFFFFCC00),
                  iconBgColor: AppTheme.primary,
                  iconColor: const Color(0xFFFFCC00),
                  actionColor: AppTheme.primary,
                  onTap: () async {
                    await AppTheme.setRole(designer: true);
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pushNamed(context, '/designer_signup');
                  },
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _buildIdentityCard(
                  context,
                  title: IdentityText.customerTitle,
                  description: IdentityText.customerDescription,
                  actionText: IdentityText.customerAction,
                  icon: Icons.hail,
                  bgColor: AppTheme.surface,
                  iconBgColor: AppTheme.accentBlue,
                  iconColor: Colors.white,
                  actionColor: AppTheme.accentBlue,
                  onTap: () async {
                    await AppTheme.setRole(designer: false);
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pushNamed(context, '/customer_signup');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentityCard(
    BuildContext context, {
    required String title,
    required String description,
    required String actionText,
    required IconData icon,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
    required Color actionColor,
    required VoidCallback onTap,
  }) {
    return NeoButton(
      onTap: onTap,
      color: bgColor,
      shadowColor: AppTheme.primary,
      depth: 3,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            color: iconBgColor,
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 38),
          ),
          const SizedBox(height: 15),
          SpacedText(
            title,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              fontSize: 28,
              height: 1.03,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppTheme.primary, width: 2.25),
              ),
            ),
            padding: const EdgeInsets.only(left: 10),
            child: SpacedText(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.28,
                letterSpacing: 0,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SpacedText(
                actionText,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: actionColor,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: actionColor, size: 21),
            ],
          ),
        ],
      ),
    );
  }
}
