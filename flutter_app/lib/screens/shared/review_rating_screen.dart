import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class ReviewRatingScreen extends StatelessWidget {
  const ReviewRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SpacedText(
                ReviewText.title,
                style: AppTheme.textStyle(
                  size: AppTypeScale.title,
                  weight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.paper,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: AppTheme.primary,
                      width: AppStroke.regular,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary,
                      offset: AppTheme.hardShadowOffset,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SpacedText(
                      ReviewText.description,
                      style: AppTheme.textStyle(
                        size: AppTypeScale.body,
                        height: AppLineHeight.relaxed,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final label in ReviewText.ratingLabels)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RatingRow(label: label),
                      ),
                    const SizedBox(height: 6),
                    Container(
                      height: 88,
                      padding: const EdgeInsets.all(12),
                      decoration: AppTheme.neoFrame(color: AppTheme.paper),
                      alignment: Alignment.topLeft,
                      child: SpacedText(
                        ReviewText.inputHint,
                        style: AppTheme.textStyle(
                          size: AppTypeScale.caption,
                          color: AppTheme.primary.withValues(alpha: 0.48),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentRed,
                            offset: AppTheme.hardShadowOffset,
                          ),
                        ],
                      ),
                      child: SpacedText(
                        ReviewText.submit,
                        style: AppTheme.textStyle(
                          color: AppTheme.paper,
                          size: AppTypeScale.button,
                          weight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;

  const _RatingRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SpacedText(
            label,
            style: AppTheme.textStyle(size: AppTypeScale.body),
          ),
        ),
        Row(
          children: List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.star, size: 18, color: AppTheme.accentYellow),
            ),
          ),
        ),
      ],
    );
  }
}
