import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class FolderProjectCard extends StatelessWidget {
  final String projectName;
  final String concept;
  final List<String> tags;
  final Color tabColor;
  final Color bodyColor;

  const FolderProjectCard({
    super.key,
    required this.projectName,
    required this.concept,
    this.tags = const [],
    this.tabColor = AppTheme.accentRed,
    this.bodyColor = AppTheme.surface,
  });

  @override
  Widget build(BuildContext context) {
    // We use a LayoutBuilder so we can measure constraints if needed,
    // but IntrinsicWidth on the tab works better for dynamic text.
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Body
          Container(
            margin: const EdgeInsets.only(top: 36), // Adjust for tab height
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: BoxDecoration(
              color: bodyColor,
              border: Border.all(color: AppTheme.primary, width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.primary,
                  offset: AppTheme.hardShadowOffset,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacedText(
                  concept,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    height: 1.45,
                    color: AppTheme.primary,
                  ),
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((t) => _buildFolderTag(t)).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Folder Tab
          Positioned(
            top: 0,
            left: 0,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: tabColor,
                      border: const Border(
                        top: BorderSide(color: AppTheme.primary, width: 1.0),
                        left: BorderSide(color: AppTheme.primary, width: 1.0),
                        right: BorderSide(color: AppTheme.primary, width: 1.0),
                      ),
                    ),
                    child: SpacedText(
                      projectName,
                      style: TextStyle(
                        color: AppTheme.onAccent(tabColor),
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  // Small connecting block to cover the top border of the main body
                  Container(
                    height: 2.0,
                    margin: const EdgeInsets.only(
                      left: 2,
                      right: 2,
                    ), // indent to keep left/right borders visible
                    color: tabColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.primary, width: 0.75),
      ),
      child: SpacedText(
        tag,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 8,
          fontFamily: 'Space Grotesk',
          color: AppTheme.primary,
        ),
      ),
    );
  }
}
