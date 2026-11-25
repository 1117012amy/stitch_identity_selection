import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import '../../core/neo_button.dart';

class NewWorkScreen extends StatefulWidget {
  const NewWorkScreen({super.key});

  @override
  State<NewWorkScreen> createState() => _NewWorkScreenState();
}

class _NewWorkScreenState extends State<NewWorkScreen> {
  final List<String> fields = List<String>.from(NewWorkText.fields);
  final List<String> selectedFields = [];

  final List<String> styles = List<String>.from(NewWorkText.styles);
  final List<String> selectedStyles = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _conceptController = TextEditingController();

  bool _isUploaded = false;
  bool _isAnalyzing = false;
  final List<Uint8List> _uploadedImages = [];
  Uint8List? _uploadedImageBytes;
  double? _uploadedImageAspectRatio;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final remainingSlots = 10 - _uploadedImages.length;
      if (remainingSlots <= 0) {
        return;
      }

      final images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final selectedImages = images.take(remainingSlots).toList();
        final imageBytes = <Uint8List>[];
        for (final image in selectedImages) {
          imageBytes.add(await image.readAsBytes());
        }

        final mainImageBytes = _uploadedImageBytes ?? imageBytes.first;
        final aspectRatio =
            _uploadedImageAspectRatio ??
            await _readImageAspectRatio(mainImageBytes);
        setState(() {
          _uploadedImages.addAll(imageBytes);
          _uploadedImageBytes = mainImageBytes;
          _uploadedImageAspectRatio = aspectRatio;
          _isUploaded = _uploadedImages.isNotEmpty;
          _isAnalyzing = true;
          selectedStyles.clear();
        });
        await _analyzeImageStyle(mainImageBytes);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<double?> _readImageAspectRatio(Uint8List bytes) async {
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    if (image.height == 0) {
      return null;
    }
    return image.width / image.height;
  }

  Future<void> _analyzeImageStyle(Uint8List bytes) async {
    try {
      // Simulate real AI processing time for UX
      await Future.delayed(const Duration(milliseconds: 1500));

      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        MemoryImage(bytes),
        maximumColorCount: 10,
      );

      Set<String> detectedStyles = {};

      if (palette.dominantColor != null) {
        final hsl = HSLColor.fromColor(palette.dominantColor!.color);
        if (hsl.lightness > 0.75) {
          detectedStyles.addAll(NewWorkText.lightTags);
        } else if (hsl.lightness < 0.3) {
          detectedStyles.addAll(NewWorkText.darkTags);
        }
        if (hsl.saturation > 0.6) {
          detectedStyles.addAll(NewWorkText.vividTags);
        }
      }

      if (palette.vibrantColor != null) {
        detectedStyles.add(NewWorkText.vibrantTag);
      }

      if (palette.mutedColor != null) {
        detectedStyles.add(NewWorkText.mutedTag);
      }

      if (detectedStyles.isEmpty) {
        detectedStyles.add(NewWorkText.fallbackTag);
      }

      setState(() {
        _isAnalyzing = false;
        for (var s in detectedStyles) {
          if (!styles.contains(s)) styles.add(s);
          if (!selectedStyles.contains(s)) selectedStyles.add(s);
        }
      });
    } catch (e) {
      debugPrint("Palette Error: $e");
      setState(() {
        _isAnalyzing = false;
        if (!selectedStyles.contains(NewWorkText.fallbackTag)) {
          selectedStyles.add(NewWorkText.fallbackTag);
        }
      });
    }
  }

  Widget _buildChip(String text, List<String> selectionList) {
    final isSelected = selectionList.contains(text);
    final selectedIndex = selectionList.indexOf(text);

    Color bgColor = AppTheme.surface;
    Color textColor = AppTheme.primary;

    if (isSelected) {
      const colors = [
        AppTheme.accentRed,
        AppTheme.accentYellow,
        AppTheme.accentBlue,
        AppTheme.primary,
        Colors.white,
      ];
      bgColor = colors[selectedIndex % colors.length];
      textColor = AppTheme.onAccent(bgColor);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectionList.remove(text);
          } else {
            selectionList.add(text);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: AppTheme.primary, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.primary,
              offset: AppTheme.hardShadowOffset,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _showAddDialog(
    List<String> targetList,
    List<String> targetSelectedList,
  ) {
    String newText = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: AppTheme.primary, width: 1.5),
          ),
          title: const Text(
            NewWorkText.dialogTitle,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              color: AppTheme.primary,
              fontSize: 17,
            ),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            decoration: const InputDecoration(
              hintText: NewWorkText.dialogHint,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.accentYellow,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.zero,
              ),
            ),
            onChanged: (val) => newText = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                NewWorkText.cancel,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            NeoButton(
              onTap: () {
                if (newText.trim().isNotEmpty) {
                  setState(() {
                    targetList.add(newText.trim());
                    targetSelectedList.add(newText.trim());
                  });
                }
                Navigator.pop(context);
              },
              color: AppTheme.accentYellow,
              depth: 3.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: const Text(
                  NewWorkText.confirm,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddChip(
    List<String> targetList,
    List<String> targetSelectedList,
  ) {
    return GestureDetector(
      onTap: () => _showAddDialog(targetList, targetSelectedList),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.primary, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.primary,
              offset: AppTheme.hardShadowOffset,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 14, color: AppTheme.primary),
            SizedBox(width: 4),
            Text(
              NewWorkText.add,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        toolbarHeight: AppTheme.appBarHeight,
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primary,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          NewWorkText.appBarTitle,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            color: AppTheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: AppTypeScale.buttonLarge,
            height: AppLineHeight.title,
            letterSpacing: AppTracking.none,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppTheme.appBarDividerHeight),
          child: Container(
            color: AppTheme.primary,
            height: AppTheme.appBarDividerHeight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              NewWorkText.nameLabel,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: const NeoBoxDecoration(color: AppTheme.surface),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  hintText: NewWorkText.nameHint,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              NewWorkText.fieldLabel,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...fields.map((f) => _buildChip(f, selectedFields)),
                _buildAddChip(fields, selectedFields),
              ],
            ),
            const SizedBox(height: 24),

            // Dashed border container
            Stack(
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: AppTheme.hardShadowOffset,
                    child: Container(color: AppTheme.primary),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: AppTheme.primary,
                      strokeWidth: 2,
                      gap: 8,
                    ),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: AppTheme.surface,
                      child: _isAnalyzing
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primary,
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  NewWorkText.uploadAnalyzing,
                                  style: TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            )
                          : _uploadedImageBytes != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(
                                  _uploadedImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.4),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 36,
                                      color: AppTheme.accentYellow,
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      color: AppTheme.primary,
                                      child: const Text(
                                        NewWorkText.uploadDone,
                                        style: TextStyle(
                                          fontFamily: 'Space Grotesk',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${NewWorkText.uploadedCountPrefix}${_uploadedImages.length}${NewWorkText.uploadedCountSuffix}',
                                      style: const TextStyle(
                                        fontFamily: 'Space Grotesk',
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.paper,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 36,
                                  color: AppTheme.primary,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  NewWorkText.uploadHint,
                                  style: TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_isUploaded) ...[
              const Text(
                NewWorkText.styleLabel,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...styles.map((s) => _buildChip(s, selectedStyles)),
                  _buildAddChip(styles, selectedStyles),
                ],
              ),
              const SizedBox(height: 24),
            ],

            const Text(
              NewWorkText.conceptLabel,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 140,
              decoration: const NeoBoxDecoration(color: AppTheme.surface),
              child: TextField(
                controller: _conceptController,
                maxLines: null,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  hintText: NewWorkText.conceptHint,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            NeoButton(
              onTap: () {
                final arguments = _buildProjectDetailArguments(
                  closeMode: 'designerProfile',
                );
                AppTheme.saveDesignerProject(
                  DesignerSavedProject(
                    title: arguments['projectName'] as String,
                    concept: arguments['conceptText'] as String,
                    tags: _savedProjectTags(),
                    fieldTags: List<String>.from(selectedFields),
                    styleTags: List<String>.from(selectedStyles),
                    imageBytes: _uploadedImageBytes,
                    imageBytesList: List<Uint8List>.from(_uploadedImages),
                    imageAspectRatio: _uploadedImageAspectRatio,
                  ),
                );
                // 儲存後連結到 Project Detail (Bauhaus Colors)，帶入標題、敘述與圖片
                Navigator.pushNamed(
                  context,
                  '/project_detail',
                  arguments: arguments,
                );
              },
              color: AppTheme.accentYellow,
              depth: 3.0,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                child: const Text(
                  NewWorkText.saveProject,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    NewWorkText.saveDraft,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  // 預覽：只查看詳情頁，不儲存、不上傳
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/project_detail',
                    arguments: _buildProjectDetailArguments(
                      closeMode: 'preview',
                    ),
                  ),
                  child: const Text(
                    NewWorkText.preview,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _buildProjectDetailArguments({
    required String closeMode,
  }) {
    final projectName = _nameController.text.trim().isEmpty
        ? AppText.unnamedProject
        : _nameController.text.trim();

    return {
      'projectName': projectName,
      'authorName': AppTheme.designerNickname,
      'imageBytes': _uploadedImageBytes,
      'imageBytesList': List<Uint8List>.from(_uploadedImages),
      'conceptText': _conceptController.text.trim(),
      'tags': [...selectedFields, ...selectedStyles],
      'fieldTags': List<String>.from(selectedFields),
      'styleTags': List<String>.from(selectedStyles),
      'authorTags': DesignerProfileText.defaultTags,
      'authorRecentImages': _authorRecentImages(),
      'closeMode': closeMode,
    };
  }

  List<Uint8List> _authorRecentImages() {
    return AppTheme.designerProjects
        .expand((project) => project.imageBytesList)
        .take(6)
        .toList();
  }

  List<String> _savedProjectTags() {
    if (selectedStyles.isNotEmpty) {
      return List<String>.from(selectedStyles);
    }
    if (selectedFields.isNotEmpty) {
      return List<String>.from(selectedFields);
    }
    return const ['#BRUTALIST'];
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    this.color = AppTheme.primary,
    this.strokeWidth = 2,
    this.gap = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Path dashPath = Path();
    double dashWidth = gap;
    double dashSpace = gap;

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
