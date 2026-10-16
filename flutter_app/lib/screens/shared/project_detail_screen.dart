import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];
  bool _initialized = false;
  int _likeCount = 0;
  int _shareCount = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _comments.add(text);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    final args = rawArgs is Map<String, dynamic> ? rawArgs : null;
    final projectName =
        args?['projectName'] as String? ?? ProjectDetailText.defaultProjectName;
    final authorName =
        args?['authorName'] as String? ?? AppTheme.designerNickname;
    final imageBytes = args?['imageBytes'] as Uint8List?;
    final imageBytesList =
        (args?['imageBytesList'] as List?)?.whereType<Uint8List>().toList() ??
        (imageBytes == null ? const <Uint8List>[] : <Uint8List>[imageBytes]);
    final conceptText = args?['conceptText'] as String? ?? '';
    final closeMode = args?['closeMode'] as String? ?? 'designerProfile';
    final styleTags =
        (args?['styleTags'] as List?)?.whereType<String>().toList() ??
        (args?['tags'] as List?)?.whereType<String>().toList() ??
        ProjectDetailText.defaultTags;
    final authorTags =
        (args?['authorTags'] as List?)?.whereType<String>().toList() ??
        DesignerProfileText.defaultTags;
    final initialComments =
        (args?['comments'] as List?)?.whereType<String>().toList() ??
        const <String>[];
    final authorRecentImages =
        (args?['authorRecentImages'] as List?)
            ?.whereType<Uint8List>()
            .toList() ??
        const <Uint8List>[];
    if (!_initialized) {
      _comments.addAll(initialComments);
      _likeCount = args?['likeCount'] as int? ?? 0;
      _shareCount = args?['shareCount'] as int? ?? 0;
      _initialized = true;
    }
    final showFooterMetrics = closeMode == 'designerProfileReturn';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              context,
              projectName: projectName,
              authorName: authorName,
              closeMode: closeMode,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProjectImages(imageBytesList),
                    _buildProjectInfo(projectName, conceptText, styleTags),
                    _buildCommentsSection(_comments),
                    _buildCommentInput(),
                    _buildAuthorInfo(authorName, authorTags),
                    _buildRecommendations(authorRecentImages),
                    if (showFooterMetrics)
                      _buildFooterMetrics(
                        likeCount: _likeCount,
                        shareCount: _shareCount,
                        commentCount: _comments.length,
                      )
                    else
                      const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String projectName,
    required String authorName,
    required String closeMode,
  }) {
    return Container(
      height: AppTheme.appBarHeight + AppTheme.appBarDividerHeight,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primary,
            width: AppTheme.appBarDividerHeight,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 1.12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                authorName,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if ((closeMode == 'preview' ||
                      closeMode == 'designerProfileReturn' ||
                      closeMode == 'customerFeed') &&
                  Navigator.canPop(context)) {
                Navigator.pop(context);
                return;
              }

              if (closeMode == 'customerFeed') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/discovery_feed',
                  (route) => false,
                );
                return;
              }

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/designer_profile',
                (route) => false,
              );
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.accentYellow,
                border: Border.all(color: AppTheme.primary, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppTheme.primary,
                    offset: AppTheme.hardShadowOffset,
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: AppTheme.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectImages(List<Uint8List> imageBytesList) {
    if (imageBytesList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: imageBytesList
            .map(
              (imageBytes) => SizedBox(
                width: double.infinity,
                child: Image.memory(
                  imageBytes,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
            .toList(),
      );
    }

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.accentBlue,
          border: Border(
            bottom: BorderSide(color: AppTheme.primary, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectInfo(
    String projectName,
    String conceptText,
    List<String> styleTags,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  projectName,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _likeCount += 1;
                  });
                },
                child: const Icon(
                  Icons.favorite_border,
                  color: AppTheme.accentRed,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _shareCount += 1;
                  });
                },
                child: const Icon(
                  Icons.near_me,
                  color: AppTheme.primary,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            ProjectDetailText.date,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: AppTheme.primary.withValues(alpha: 0.6),
            ),
          ),
          if (styleTags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: styleTags.take(3).indexed
                  .map((entry) => _buildTag(entry.$2, _tagColor(entry.$1)))
                  .toList(),
            ),
          ],
          if (conceptText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              conceptText,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.45,
                color: AppTheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentsSection(List<String> comments) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      padding: const EdgeInsets.all(12),
      decoration: const NeoBoxDecoration(color: AppTheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comments.isEmpty)
            const SizedBox(
              height: 26,
              child: Center(
                child: Text(
                  ProjectDetailText.noComments,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            )
          else ...[
            const Text(
              ProjectDetailText.comments,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 10),
            for (final entry in comments.take(3)) ...[
              _buildCommentItem(entry, _commentColor(comments.indexOf(entry))),
              const SizedBox(height: 8),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.primary,
                      offset: AppTheme.hardShadowOffset,
                    ),
                  ],
                ),
                child: const Text(
                  ProjectDetailText.moreComments,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _commentColor(int index) {
    return switch (index % 3) {
      0 => AppTheme.accentRed,
      1 => AppTheme.accentBlue,
      _ => AppTheme.accentYellow,
    };
  }

  Color _tagColor(int index) {
    return switch (index % 3) {
      0 => AppTheme.accentRed,
      1 => AppTheme.accentBlue,
      _ => AppTheme.accentYellow,
    };
  }

  Widget _buildCommentItem(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2.25)),
      ),
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.primary, width: 1.5),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _commentController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(),
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppTheme.primary,
                  height: 1.1,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: ProjectDetailText.commentHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppTheme.primary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _submitComment,
            child: Container(
              width: 52,
              height: 42,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                border: Border(
                  top: BorderSide(color: AppTheme.primary, width: 1.5),
                  right: BorderSide(color: AppTheme.primary, width: 1.5),
                  bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(String authorName, List<String> tags) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            ProjectDetailText.authorTitle,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: -0.75,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentYellow,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.primary,
                      offset: AppTheme.hardShadowOffset,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                authorName,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: tags.take(3).map((tag) {
              final index = tags.indexOf(tag);
              final color = switch (index % 3) {
                0 => AppTheme.accentRed,
                1 => AppTheme.accentBlue,
                _ => AppTheme.accentYellow,
              };
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _buildTag(tag, color),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildRecommendations(List<Uint8List> recentImages) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (final image in recentImages.take(6)) ...[
              _buildRecCard(image),
              const SizedBox(width: 10),
            ],
            if (recentImages.isEmpty) ...[
              _buildEmptyRecCard(),
              const SizedBox(width: 10),
              _buildEmptyRecCard(),
              const SizedBox(width: 10),
              _buildEmptyRecCard(),
            ],
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildRecCard(Uint8List imageBytes) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.memory(imageBytes, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildEmptyRecCard() {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppTheme.neutralLight,
        border: Border.all(color: AppTheme.primary, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.primary, offset: AppTheme.hardShadowOffset),
        ],
      ),
      child: const AspectRatio(aspectRatio: 4 / 3, child: SizedBox()),
    );
  }

  Widget _buildFooterMetrics({
    required int likeCount,
    required int shareCount,
    required int commentCount,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 20, 15, 24),
      padding: const EdgeInsets.all(14),
      decoration: const NeoBoxDecoration(color: AppTheme.surface),
      child: Column(
        children: [
          _buildMetricRow(
            Icons.favorite,
            ProjectDetailText.likes,
            likeCount.toString(),
            AppTheme.accentRed,
            true,
          ),
          const SizedBox(height: 12),
          _buildMetricRow(
            Icons.near_me,
            ProjectDetailText.shares,
            shareCount.toString(),
            AppTheme.primary,
            true,
          ),
          const SizedBox(height: 12),
          _buildMetricRow(
            Icons.chat_bubble,
            ProjectDetailText.commentCount,
            commentCount.toString(),
            AppTheme.primary,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
    bool hasBorder,
  ) {
    return Container(
      padding: hasBorder ? const EdgeInsets.only(bottom: 6) : EdgeInsets.zero,
      decoration: hasBorder
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.primary, width: 1.0),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
