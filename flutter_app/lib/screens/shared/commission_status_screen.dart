import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class CommissionStatusScreen extends StatelessWidget {
  const CommissionStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title & Stats Section
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const NeoBoxDecoration(
                          color: AppTheme.accentYellow,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SpacedText(
                              CommissionText.title,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                height: 1.03,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(height: 4),
                            SpacedText(
                              CommissionText.subtitle,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const NeoBoxDecoration(
                          color: AppTheme.surface,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpacedText(
                              '0',
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontWeight: FontWeight.w900,
                                fontSize: 33,
                              ),
                            ),
                            SpacedText(
                              CommissionText.activeCount,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.primary, width: 2.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTab(CommissionText.tabs[0], isActive: true),
                      _buildTab(CommissionText.tabs[1]),
                      _buildTab(CommissionText.tabs[2], isLast: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Empty State
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.primary, width: 1.0),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: AppTheme.primary),
                    SizedBox(height: 12),
                    SpacedText(
                      CommissionText.empty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        height: 1.36,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/commission_status',
      ),
    );
  }

  Widget _buildTab(String text, {bool isActive = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.accentYellow : AppTheme.surface,
        border: Border(
          right: BorderSide(color: AppTheme.primary, width: isLast ? 0 : 2),
        ),
      ),
      child: SpacedText(
        text,
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
          fontSize: 12,
          color: AppTheme.primary,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
