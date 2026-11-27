import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class SearchCategoriesScreen extends StatelessWidget {
  const SearchCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: true,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const NeoBoxDecoration(color: AppTheme.surface),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: SearchCategoriesText.searchHint,
                              hintStyle: TextStyle(letterSpacing: kSmallChineseLetterSpacing,
                                fontFamily: 'Space Grotesk',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppTheme.primary.withValues(alpha: 0.4),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentYellow,
                          foregroundColor: AppTheme.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: const BorderSide(
                            color: AppTheme.primary,
                            width: 1.0,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 0,
                        ),
                        child: const SpacedText(
                          SearchCategoriesText.search,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SpacedText(
                    SearchCategoriesText.categoryTitle,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 1.75,
                      color: AppTheme.primary,
                      margin: const EdgeInsets.only(bottom: 3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildCategoryCard(
                        SearchCategoriesText.categories[0].title,
                        SearchCategoriesText.categories[0].subtitle,
                        AppTheme.accentYellow,
                      ),
                      const SizedBox(width: 10),
                      _buildCategoryCard(
                        SearchCategoriesText.categories[1].title,
                        SearchCategoriesText.categories[1].subtitle,
                        AppTheme.accentBlue,
                      ),
                      const SizedBox(width: 10),
                      _buildCategoryCard(
                        SearchCategoriesText.categories[2].title,
                        SearchCategoriesText.categories[2].subtitle,
                        AppTheme.accentRed,
                      ),
                      const SizedBox(width: 10),
                      _buildCategoryCard(
                        SearchCategoriesText.categories[3].title,
                        SearchCategoriesText.categories[3].subtitle,
                        const Color(0xFF6BCB77),
                      ),
                      const SizedBox(width: 10),
                      _buildCategoryCard(
                        SearchCategoriesText.categories[4].title,
                        SearchCategoriesText.categories[4].subtitle,
                        const Color(0xFFFF6B6B),
                      ),
                      const SizedBox(width: 10),
                      _buildCategoryCard(
                        SearchCategoriesText.categories[5].title,
                        SearchCategoriesText.categories[5].subtitle,
                        const Color(0xFFB388FF),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.grid_view, size: 20),
                  SizedBox(width: 8),
                  SpacedText(
                    SearchCategoriesText.recentProjects,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _buildProjectCard(
                    title: SearchCategoriesText.projectTitle,
                    tag: SearchCategoriesText.projectTag,
                    isLarge: true,
                    bgColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProjectCard(
                          title: SearchCategoriesText.colorProject,
                          tag: '',
                          isLarge: false,
                          bgColor: const Color(0xFFFFF5CC),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildProjectCard(
                          title: SearchCategoriesText.modelProject,
                          tag: '',
                          isLarge: false,
                          bgColor: const Color(0xFFFDE8E8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const NeoBoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.primary,
                              width: 1.5,
                            ),
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpacedText(
                                SearchCategoriesText.projectTag,
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                  color: AppTheme.accentRed,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const SpacedText(
                                SearchCategoriesText.modelProject,
                                style: TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.primary,
                                      ),
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.primary,
                                      ),
                                      color: AppTheme.accentYellow,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.primary,
                                      ),
                                      color: AppTheme.accentRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/search_categories',
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, Color bgColor) {
    return Container(
      width: 140,
      decoration: const NeoBoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: const Border(
                  bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpacedText(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                      SpacedText(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.north_east, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String tag,
    required bool isLarge,
    required Color bgColor,
  }) {
    return Container(
      decoration: NeoBoxDecoration(color: bgColor),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isLarge ? 160 : 90,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary, width: 1.5),
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 10),
          if (tag.isNotEmpty) ...[
            SpacedText(
              tag,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: AppTheme.accentBlue,
              ),
            ),
            const SizedBox(height: 2),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SpacedText(
                  title,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: isLarge ? 15 : 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isLarge) const Icon(Icons.favorite, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
