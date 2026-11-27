import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import 'package:flutter/gestures.dart';
import '../../core/neo_button.dart';

class DiscoveryFeedScreen extends StatelessWidget {
  const DiscoveryFeedScreen({super.key});

  static const List<DiscoverySample> _leftItems = DiscoveryText.samplesLeft;
  static const List<DiscoverySample> _rightItems = DiscoveryText.samplesRight;

  @override
  Widget build(BuildContext context) {
    final savedProjects = AppTheme.designerProjects;
    final savedLeftProjects = <_SavedProjectTile>[];
    final savedRightProjects = <_SavedProjectTile>[];
    var leftHeight = 0.0;
    var rightHeight = 0.0;
    for (var i = 0; i < savedProjects.length; i++) {
      final tile = _SavedProjectTile(
        project: savedProjects[i],
        accent: _tagAccentForIndex(i),
      );
      final estimatedHeight = _estimatedSavedProjectHeight(savedProjects[i]);
      if (leftHeight <= rightHeight) {
        savedLeftProjects.add(tile);
        leftHeight += estimatedHeight;
      } else {
        savedRightProjects.add(tile);
        rightHeight += estimatedHeight;
      }
    }

    return Scaffold(
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category filter pills
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: Container(
                  color: AppTheme.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPill(DiscoveryText.categories[0], isActive: true),
                        const SizedBox(width: 8),
                        _buildPill(DiscoveryText.categories[1]),
                        const SizedBox(width: 8),
                        _buildPill(DiscoveryText.categories[2]),
                        const SizedBox(width: 8),
                        _buildPill(DiscoveryText.categories[3]),
                        const SizedBox(width: 8),
                        _buildPill(DiscoveryText.categories[4]),
                      ],
                    ),
                  ),
                ),
              ),
              Container(height: 3, color: AppTheme.primary),

              // Section header
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 14, 15, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SpacedText(
                      DiscoveryText.sectionTitle,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 21,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: AppTheme.primary,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SpacedText(
                      DiscoveryText.itemCount,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),

              // Masonry grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ...savedLeftProjects.map(
                            (tile) =>
                                _buildSavedProjectCard(context, tile: tile),
                          ),
                          ..._leftItems.indexed.map(
                            (entry) => _buildMasonryCard(
                              context,
                              height: entry.$2.height,
                              label: entry.$2.label,
                              tag: entry.$2.tag,
                              accent: _tagAccentForIndex(
                                savedProjects.length + entry.$1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          ...savedRightProjects.map(
                            (tile) =>
                                _buildSavedProjectCard(context, tile: tile),
                          ),
                          ..._rightItems.indexed.map(
                            (entry) => _buildMasonryCard(
                              context,
                              height: entry.$2.height,
                              label: entry.$2.label,
                              tag: entry.$2.tag,
                              accent: _tagAccentForIndex(
                                savedProjects.length +
                                    _leftItems.length +
                                    entry.$1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/discovery_feed',
      ),
    );
  }

  Widget _buildPill(String text, {bool isActive = false}) {
    return NeoButton(
      onTap: () {},
      color: isActive ? AppTheme.primary : AppTheme.surface,
      depth: 3.0,
      borderWidth: 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: SpacedText(
        text,
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: isActive ? Colors.white : AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildMasonryCard(
    BuildContext context, {
    required double height,
    required String label,
    required String tag,
    required Color accent,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NeoButton(
        onTap: () {
          // 點擊作品方塊，連結到 Project Detail (Bauhaus Colors)
          Navigator.pushNamed(
            context,
            '/project_detail',
            arguments: {
              'projectName': label,
              'authorName': AppTheme.designerNickname,
              'styleTags': [tag],
              'tags': [tag],
              'authorTags': DesignerProfileText.defaultTags,
              'closeMode': 'customerFeed',
            },
          );
        },
        color: AppTheme.surface,
        depth: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height,
              color: const Color(0xFFEBEBEB),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                color: accent,
                child: SpacedText(
                  tag,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: AppTheme.onAccent(accent),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SpacedText(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedProjectCard(
    BuildContext context, {
    required _SavedProjectTile tile,
  }) {
    final project = tile.project;
    final tag = project.styleTags.isNotEmpty
        ? project.styleTags.first
        : project.tags.firstOrNull ?? DiscoveryText.defaultSavedTag;
    // 圖片左下方的小字顯示作品名稱
    final label = project.title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NeoButton(
        onTap: () {
          // 點擊作品卡片，連結到 Project Detail (Bauhaus Colors)
          Navigator.pushNamed(
            context,
            '/project_detail',
            arguments: {
              'projectName': project.title,
              'authorName': AppTheme.designerNickname,
              'imageBytes': project.imageBytes,
              'imageBytesList': List<Uint8List>.from(project.imageBytesList),
              'conceptText': project.concept,
              'tags': project.tags,
              'fieldTags': project.fieldTags,
              'styleTags': project.styleTags,
              'authorTags': DesignerProfileText.defaultTags,
              'closeMode': 'customerFeed',
            },
          );
        },
        color: AppTheme.surface,
        depth: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                if (project.imageBytes != null)
                  Image.memory(
                    project.imageBytes!,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  )
                else
                  Container(height: 170, color: AppTheme.neutralLight),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    color: tile.accent,
                    child: SpacedText(
                      tag,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        color: AppTheme.onAccent(tile.accent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SpacedText(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _tagAccentForIndex(int index) {
    const accents = [
      AppTheme.accentRed,
      AppTheme.accentBlue,
      AppTheme.accentYellow,
    ];
    return accents[index % accents.length];
  }

  static double _estimatedSavedProjectHeight(DesignerSavedProject project) {
    final aspectRatio = project.imageAspectRatio;
    final visualHeight = aspectRatio == null || aspectRatio <= 0
        ? 170.0
        : (170.0 / aspectRatio).clamp(100.0, 280.0);
    return visualHeight + 42.0;
  }
}

class _SavedProjectTile {
  final DesignerSavedProject project;
  final Color accent;

  const _SavedProjectTile({required this.project, required this.accent});
}
