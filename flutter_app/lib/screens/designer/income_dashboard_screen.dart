import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import '../../core/neo_button.dart';

class IncomeDashboardScreen extends StatelessWidget {
  const IncomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppTheme.isDesigner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/discovery_feed');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                decoration: const NeoBoxDecoration(
                  color: AppTheme.accentYellow,
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpacedText(
                          IncomeText.title,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const SpacedText(
                          '\$42,850.00',
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 31,
                            height: 0.94,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                border: Border.all(color: AppTheme.primary),
                              ),
                              child: const SpacedText(
                                IncomeText.monthBadge,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentBlue,
                                border: Border.all(color: AppTheme.primary),
                              ),
                              child: const SpacedText(
                                '+12.4% MOM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Positioned(
                      right: -40,
                      bottom: -40,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(
                          Icons.account_balance,
                          size: 140,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Paid Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.primary,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: IncomeText.paidPrefix,
                          style: TextStyle(letterSpacing: kTitleChineseLetterSpacing),
                        ),
                        TextSpan(
                          text: 'PAID',
                          style: TextStyle(color: AppTheme.accentBlue),
                        ),
                      ],
                    ),
                  ),
                  const SpacedText(
                    IncomeText.paidRange,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildPaidItem(
                Icons.payments,
                'Creative Studio A',
                IncomeText.paidTimes[0],
                '+\$3,200',
              ),
              const SizedBox(height: 10),
              _buildPaidItem(
                Icons.work,
                'Project Delta Ltd.',
                IncomeText.paidTimes[1],
                '+\$12,500',
              ),
              const SizedBox(height: 10),
              _buildPaidItem(
                Icons.person,
                'Individual Client B',
                IncomeText.paidTimes[2],
                '+\$850',
              ),
              const SizedBox(height: 20),

              // Unpaid Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.primary,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: IncomeText.unpaidPrefix,
                          style: TextStyle(letterSpacing: kTitleChineseLetterSpacing),
                        ),
                        TextSpan(
                          text: 'UNPAID',
                          style: TextStyle(color: AppTheme.accentRed),
                        ),
                      ],
                    ),
                  ),
                  const SpacedText(
                    IncomeText.unpaidRange,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildUnpaidItemUrgent(
                'Tech Nexus Co.',
                IncomeText.urgentDue,
                '\$5,400',
              ),
              const SizedBox(height: 10),
              _buildUnpaidItemPending(
                'Artisan Bakery',
                IncomeText.pendingDue,
                '\$1,200',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/designer_profile',
      ),
    );
  }

  Widget _buildPaidItem(
    IconData icon,
    String title,
    String time,
    String amount,
  ) {
    return Container(
      decoration: const NeoBoxDecoration(color: AppTheme.surface),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD6E3FF),
              border: Border.all(color: AppTheme.primary, width: 1.5),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacedText(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0,
                  ),
                ),
                SpacedText(
                  time,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: AppTheme.primary.withValues(alpha: 0.6),
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SpacedText(
                amount,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0,
                ),
              ),
              const SpacedText(
                IncomeText.paidStatus,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  color: AppTheme.accentBlue,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnpaidItemUrgent(String title, String status, String amount) {
    return Container(
      decoration: const NeoBoxDecoration(color: Color(0xFFE8E3DA)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentRed,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpacedText(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0,
                      ),
                    ),
                    SpacedText(
                      status,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: AppTheme.accentRed,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              SpacedText(
                amount,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: NeoButton(
                  onTap: () {},
                  color: AppTheme.primary,
                  depth: 3.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: const SpacedText(
                      IncomeText.urgentAction,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnpaidItemPending(String title, String status, String amount) {
    return Container(
      decoration: const NeoBoxDecoration(color: AppTheme.surface),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E3DA),
              border: Border.all(color: AppTheme.primary, width: 1.5),
            ),
            child: const Icon(Icons.pending, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacedText(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0,
                  ),
                ),
                SpacedText(
                  status,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: AppTheme.primary.withValues(alpha: 0.6),
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          SpacedText(
            amount,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
