import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class PortfolioManagementScreen extends StatelessWidget {
  const PortfolioManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Role guard: this page is only available in designer mode.
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpacedText(
                          PortfolioText.title,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            letterSpacing: 0,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: AppTheme.accentYellow,
                                width: 2.25,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          child: const SpacedText(
                            PortfolioText.subtitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/new_work');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      side: const BorderSide(
                        color: AppTheme.primary,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const SpacedText(
                      PortfolioText.uploadWork,
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
              const SizedBox(height: 24),

              // Filter System
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(PortfolioText.filters[0], isActive: true),
                  _buildFilterChip(PortfolioText.filters[1]),
                  _buildFilterChip(PortfolioText.filters[2]),
                  _buildFilterChip(PortfolioText.filters[3]),
                  _buildFilterChip(PortfolioText.filters[4]),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: AppTheme.accentRed,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      SpacedText(
                        PortfolioText.advancedFilter,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentRed,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.accentRed,
                          decorationThickness: 2,
                          fontSize: 11,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bento Grid Top Row
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const NeoBoxDecoration(
                        color: AppTheme.surface,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.folder, size: 36),
                                  Flexible(
                                    child: Container(
                                      color: AppTheme.accentRed,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      child: const SpacedText(
                                        PortfolioText.privateLabel,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Space Grotesk',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const SpacedText(
                                PortfolioText.featuredTitle,
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  height: 1.12,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SpacedText(
                                PortfolioText.featuredSubtitle,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.primary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '24 ',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      TextSpan(
                                        text: PortfolioText.countUnit,
                                        style: TextStyle(
                                          fontSize: 11,
                                          letterSpacing: kSmallChineseLetterSpacing,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const NeoBoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                border: Border(
                                  right: BorderSide(
                                    color: AppTheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: AppTheme.surface,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppTheme.primary,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            child: const SpacedText(
                                              PortfolioText.sampleTag,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppTheme.primary,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            child: const SpacedText(
                                              '#INK',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const SpacedText(
                                        PortfolioText.sampleTitle,
                                        style: TextStyle(
                                          fontFamily: 'Space Grotesk',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          height: 1.12,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const SpacedText(
                                        PortfolioText.sampleDescription,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 1.75,
                                        color: AppTheme.accentYellow,
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            child: SpacedText(
                                              PortfolioText.updatedAt,
                                              style: TextStyle(
                                                fontFamily: 'Space Grotesk',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppTheme.primary,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppTheme.primary,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  size: 14,
                                                  color: AppTheme.accentRed,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
              const SizedBox(height: 12),

              // Stats Row
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const NeoBoxDecoration(
                        color: AppTheme.accentBlue,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.visibility, color: Colors.white, size: 32),
                          SizedBox(height: 4),
                          SpacedText(
                            '12.5K',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                          SpacedText(
                            PortfolioText.views,
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              color: Colors.white,
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
                        color: AppTheme.accentYellow,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.auto_awesome, size: 20),
                              Flexible(
                                child: SpacedText(
                                  PortfolioText.draft,
                                  style: TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          SpacedText(
                            PortfolioText.draftTitle,
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 1.12,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const NeoBoxDecoration(
                        color: AppTheme.surface,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SpacedText(
                                    PortfolioText.progressLabel,
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                      color: AppTheme.accentRed,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  SpacedText(
                                    PortfolioText.progressValue,
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SpacedText(
                                    PortfolioText.progressLabel,
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                      color: AppTheme.accentBlue,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  SpacedText(
                                    PortfolioText.progressValue,
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
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
                  ),
                ],
              ),
              ),
              const SizedBox(height: 24),

              // Grid Items
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGridItem(
                    PortfolioText.gridItems[0].title,
                    PortfolioText.gridItems[0].tag,
                  ),
                  _buildGridItem(
                    PortfolioText.gridItems[1].title,
                    PortfolioText.gridItems[1].tag,
                  ),
                  _buildGridItem(
                    PortfolioText.gridItems[2].title,
                    PortfolioText.gridItems[2].tag,
                  ),

                  // Add New Box
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/new_work');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEE9E0),
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle, size: 36),
                          SizedBox(height: 12),
                          SpacedText(
                            PortfolioText.newProject,
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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

  Widget _buildFilterChip(String text, {bool isActive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppTheme.accentYellow : AppTheme.surface,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SpacedText(
        text,
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
          fontSize: 11,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, String tag) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                border: Border(
                  bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacedText(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentYellow,
                          border: Border.all(color: AppTheme.primary),
                        ),
                        child: SpacedText(
                          tag,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.more_vert, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
