import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import '../../core/neo_button.dart';
import '../../core/app_icons.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: ObscureAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: AppIcons.notification(
                color: AppTheme.primary,
                size: 22,
                isFill: true,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacedText(
                        NotificationText.title,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                          height: 1.03,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                          children: [
                            TextSpan(
                              text: NotificationText.summaryPrefix,
                              style: TextStyle(letterSpacing: kSmallChineseLetterSpacing),
                            ),
                            TextSpan(
                              text: NotificationText.summaryCount,
                              style: TextStyle(color: AppTheme.accentRed),
                            ),
                            TextSpan(
                              text: NotificationText.summarySuffix,
                              style: TextStyle(letterSpacing: kSmallChineseLetterSpacing),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  NeoButton(
                    onTap: () {},
                    color: AppTheme.accentBlue,
                    depth: 3.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: const SpacedText(
                      NotificationText.markAllRead,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 11,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Tabs ??2x2 grid
              Row(
                children: [
                  Expanded(
                    child: _buildTab(NotificationText.tabs[0], isActive: true),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: _buildTab(NotificationText.tabs[1])),
                  const SizedBox(width: 6),
                  Expanded(child: _buildTab(NotificationText.tabs[2])),
                  const SizedBox(width: 6),
                  Expanded(child: _buildTab(NotificationText.tabs[3])),
                ],
              ),
              const SizedBox(height: 14),

              // Notification items
              _buildNotificationItem(
                icon: Icons.payments,
                iconBgColor: AppTheme.accentYellow,
                badgeText: NotificationText.items[0].badge,
                badgeColor: AppTheme.accentBlue,
                time: NotificationText.items[0].time,
                title: NotificationText.items[0].title,
                subtitle: NotificationText.items[0].subtitle,
                actionColor: AppTheme.primary,
                actionText: NotificationText.items[0].action,
                shadowColor: AppTheme.accentBlue,
              ),
              const SizedBox(height: 10),
              _buildNotificationItem(
                icon: Icons.star,
                iconBgColor: Colors.white,
                badgeText: NotificationText.items[1].badge,
                badgeColor: AppTheme.accentRed,
                time: NotificationText.items[1].time,
                title: NotificationText.items[1].title,
                subtitle: NotificationText.items[1].subtitle,
                actionColor: AppTheme.accentBlue,
                actionText: NotificationText.items[1].action,
                bgColor: AppTheme.accentYellow,
                shadowColor: AppTheme.primary,
              ),
              const SizedBox(height: 10),
              _buildNotificationItem(
                icon: Icons.architecture,
                iconBgColor: AppTheme.accentBlue,
                iconColor: Colors.white,
                badgeText: NotificationText.items[2].badge,
                badgeColor: AppTheme.primary,
                time: NotificationText.items[2].time,
                title: NotificationText.items[2].title,
                subtitle: NotificationText.items[2].subtitle,
                actionColor: AppTheme.accentYellow,
                actionText: NotificationText.items[2].action,
                actionTextColor: AppTheme.primary,
                shadowColor: AppTheme.accentRed,
              ),
              const SizedBox(height: 10),
              _buildNotificationItem(
                icon: Icons.settings,
                iconBgColor: const Color(0xFFE0E0E0),
                badgeText: NotificationText.items[3].badge,
                badgeColor: Colors.grey,
                time: NotificationText.items[3].time,
                title: NotificationText.items[3].title,
                subtitle: NotificationText.items[3].subtitle,
                isSystem: true,
                shadowColor: Colors.transparent,
              ),
              const SizedBox(height: 20),

              // Footer Stats
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    _buildStatBox(
                      '84%',
                      NotificationText.responseRate,
                      AppTheme.accentBlue,
                      Colors.white,
                    ),
                    _buildStatBox(
                      '12',
                      NotificationText.pendingTasks,
                      Colors.white,
                      AppTheme.primary,
                    ),
                    _buildStatBox(
                      '\$4.2K',
                      NotificationText.monthlyIncome,
                      AppTheme.accentYellow,
                      AppTheme.primary,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, {bool isActive = false}) {
    return NeoButton(
      onTap: () {},
      color: isActive ? AppTheme.accentRed : Colors.white,
      depth: AppTheme.hardShadowDepth,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: SpacedText(
          title,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w900,
            color: isActive ? Colors.white : AppTheme.primary,
            fontSize: 11,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconBgColor,
    Color iconColor = AppTheme.primary,
    required String badgeText,
    required Color badgeColor,
    required String time,
    required String title,
    required String subtitle,
    Color bgColor = Colors.white,
    Color shadowColor = AppTheme.primary,
    bool isSystem = false,
    String? actionText,
    Color? actionColor,
    Color actionTextColor = Colors.white,
  }) {
    return Opacity(
      opacity: isSystem ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: AppTheme.primary, width: 1.5),
          boxShadow: shadowColor != Colors.transparent
              ? [
                  BoxShadow(
                    color: shadowColor,
                    offset: AppTheme.hardShadowOffset,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: badgeColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: SpacedText(
                              badgeText,
                              style: const TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          SpacedText(
                            time,
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary.withValues(alpha: 0.5),
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SpacedText(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SpacedText(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (actionText != null && actionColor != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: NeoButton(
                      onTap: () {},
                      color: actionColor,
                      depth: 3.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        alignment: Alignment.center,
                        child: SpacedText(
                          actionText,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.bold,
                            color: actionTextColor,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, size: 20),
                ],
              ),
            ],
            if (isSystem) ...[
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete_outline, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
    String value,
    String label,
    Color bgColor,
    Color textColor, {
    bool isLast = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        border: !isLast
            ? const Border(
                bottom: BorderSide(color: AppTheme.primary, width: 1.5),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SpacedText(
            label,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0,
            ),
          ),
          SpacedText(
            value,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
