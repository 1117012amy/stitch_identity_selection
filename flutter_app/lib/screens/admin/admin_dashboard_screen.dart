import 'package:flutter/material.dart';

import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 24, 15, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacedText(
                    AdminText.title,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      height: 0.86,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: AppTheme.accentBlue,
                          width: 2.25,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 12, top: 3, bottom: 3),
                    child: const SpacedText(
                      AdminText.subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: AppTheme.primary, width: 1.5),
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                    ),
                    child: const SpacedText(
                      AdminText.exportReport,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLargeStatCard(
                AdminText.newUsers,
                '124',
                '+12%',
                Icons.person_add,
                Colors.white,
                null,
              ),
              const SizedBox(height: 10),
              _buildTargetStatCard(
                AdminText.monthlyRevenue,
                '\$2.4M',
                AppTheme.accentYellow,
                0.8,
              ),
              const SizedBox(height: 10),
              _buildDisputeStatCard(
                AdminText.disputes,
                '18',
                AppTheme.accentRed,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SpacedText(
                    AdminText.verificationTitle,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(Icons.filter_list, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(Icons.search, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      color: AppTheme.primary,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SpacedText(
                            AdminText.verificationName,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          SpacedText(
                            AdminText.verificationLocation,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildVerificationRow(
                      'Anton Vogler',
                      'Berlin, DE',
                      AppTheme.accentBlue,
                    ),
                    const Divider(
                      color: AppTheme.primary,
                      height: 1.75,
                      thickness: 2,
                    ),
                    _buildVerificationRow(
                      'Elena Rossi',
                      'Milan, IT',
                      AppTheme.accentYellow,
                    ),
                    const Divider(
                      color: AppTheme.primary,
                      height: 1.75,
                      thickness: 2,
                    ),
                    _buildVerificationRow(
                      'Marcus Chen',
                      'Tokyo, JP',
                      Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const SpacedText(
                AdminText.disputeTitle,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              _buildDisputeItem(
                '#88219',
                AdminText.firstDisputeTitle,
                '\$1,200',
                AdminText.firstDisputeDescription,
                isHighPriority: true,
              ),
              const SizedBox(height: 10),
              _buildDisputeItem(
                '#88224',
                AdminText.secondDisputeTitle,
                '\$450',
                AdminText.secondDisputeDescription,
                isHighPriority: false,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue,
                  border: Border.all(color: AppTheme.primary, width: 2.25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacedText(
                      AdminText.systemHealth,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const SpacedText(
                          AdminText.systemOnline,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHealthStat(AdminText.cpuLoad, '22%'),
                        ),
                        Expanded(
                          child: _buildHealthStat(AdminText.latency, '14ms'),
                        ),
                      ],
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
        activeRoute: '/admin_dashboard',
      ),
    );
  }

  Widget _buildLargeStatCard(
    String title,
    String mainValue,
    String subValue,
    IconData icon,
    Color bgColor,
    Color? borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor ?? AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SpacedText(
                title,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Icon(icon, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SpacedText(
                mainValue,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 37,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                  height: 0.94,
                ),
              ),
              const SizedBox(width: 10),
              SpacedText(
                subValue,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetStatCard(
    String title,
    String mainValue,
    Color bgColor,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedText(
            title,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          SpacedText(
            mainValue,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 33,
              fontWeight: FontWeight.w900,
              height: 0.94,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.primary, width: 1.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacedText(
                  AdminText.revenueTarget,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(color: AppTheme.accentBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeStatCard(String title, String mainValue, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedText(
            title,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          SpacedText(
            mainValue,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 37,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 0.94,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            alignment: Alignment.center,
            child: const SpacedText(
              AdminText.viewDetails,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationRow(String name, String location, Color avatarBg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: avatarBg,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacedText(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SpacedText(
                    location,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.cancel,
                  color: AppTheme.accentRed,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeItem(
    String id,
    String title,
    String amount,
    String desc, {
    bool isHighPriority = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isHighPriority)
            Positioned(
              top: -24,
              right: -24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed,
                  border: Border.all(color: AppTheme.primary, width: 1.0),
                ),
                child: const SpacedText(
                  AdminText.highPriority,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpacedText(
                          '${AdminText.disputeIdPrefix} $id',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        SpacedText(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SpacedText(
                    amount,
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SpacedText(
                desc,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  height: 1.28,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      color: AppTheme.primary,
                      alignment: Alignment.center,
                      child: const SpacedText(
                        AdminText.handle,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primary, width: 1.5),
                    ),
                    child: const Icon(Icons.more_vert, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white30, width: 0.75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedText(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          SpacedText(
            value,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
