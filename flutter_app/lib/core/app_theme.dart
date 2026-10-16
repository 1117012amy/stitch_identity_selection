import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'app_text.dart';
import 'app_icons.dart';
import 'fade_slide_route.dart';
import 'project_storage_stub.dart'
    if (dart.library.html) 'project_storage_web.dart';
import '../screens/shared/notification_center_screen.dart';

class DesignerSavedProject {
  final String title;
  final String concept;
  final List<String> tags;
  final List<String> fieldTags;
  final List<String> styleTags;
  final Uint8List? imageBytes;
  final List<Uint8List> imageBytesList;
  final double? imageAspectRatio;

  const DesignerSavedProject({
    required this.title,
    required this.concept,
    required this.tags,
    this.fieldTags = const [],
    this.styleTags = const [],
    this.imageBytes,
    this.imageBytesList = const [],
    this.imageAspectRatio,
  });

  factory DesignerSavedProject.fromJson(Map<String, dynamic> json) {
    final imageBase64 = json['imageBase64'] as String?;
    final imageList =
        (json['imageBase64List'] as List?)
            ?.whereType<String>()
            .where((value) => value.isNotEmpty)
            .map(base64Decode)
            .toList() ??
        const <Uint8List>[];
    final legacyImageBytes = imageBase64 == null || imageBase64.isEmpty
        ? null
        : base64Decode(imageBase64);
    return DesignerSavedProject(
      title: json['title'] as String? ?? AppText.unnamedProject,
      concept: json['concept'] as String? ?? '',
      tags: (json['tags'] as List?)?.whereType<String>().toList() ?? const [],
      fieldTags:
          (json['fieldTags'] as List?)?.whereType<String>().toList() ??
          const [],
      styleTags:
          (json['styleTags'] as List?)?.whereType<String>().toList() ??
          const [],
      imageBytes: legacyImageBytes ?? imageList.firstOrNull,
      imageBytesList: imageList.isNotEmpty
          ? imageList
          : (legacyImageBytes == null
                ? const <Uint8List>[]
                : <Uint8List>[legacyImageBytes]),
      imageAspectRatio: (json['imageAspectRatio'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'concept': concept,
      'tags': tags,
      'fieldTags': fieldTags,
      'styleTags': styleTags,
      'imageBase64': imageBytes == null ? null : base64Encode(imageBytes!),
      'imageBase64List': imageBytesList.map(base64Encode).toList(),
      'imageAspectRatio': imageAspectRatio,
    };
  }
}

class AppTheme {
  static bool isDesigner = false;
  static String designerNickname = AppText.defaultDesignerName;
  static final List<DesignerSavedProject> designerProjects = [];

  static Future<void> loadDesignerProjects() async {
    final projects = await ProjectStorage.loadDesignerProjects();
    final roleState = await ProjectStorage.loadRoleState();
    designerProjects
      ..clear()
      ..addAll(projects);
    isDesigner = roleState['role'] == 'designer';
    final savedNickname = roleState['designerNickname'];
    if (savedNickname != null && savedNickname.isNotEmpty) {
      designerNickname = savedNickname;
    }
  }

  static void saveDesignerProject(DesignerSavedProject project) {
    designerProjects.insert(0, project);
    ProjectStorage.saveDesignerProjects(designerProjects);
  }

  static Future<void> setRole({
    required bool designer,
    String? nickname,
  }) async {
    isDesigner = designer;
    if (nickname != null && nickname.isNotEmpty) {
      designerNickname = nickname;
    }
    await ProjectStorage.saveRoleState(
      isDesigner: isDesigner,
      designerNickname: designerNickname,
    );
  }

  // Core software palette. Use these constants instead of raw Color values.
  static const Color ink = Color(0xFF1A1A1A);
  static const Color canvas = Color(0xFFF5F0E8);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color yellow = Color(0xFFFFCC00);
  static const Color red = Color(0xFFE63B2E);
  static const Color blue = Color(0xFF0055FF);
  static const Color green = Color(0xFF00C853);
  static const Color purple = Color(0xFFAA00FF);

  // Supporting palette found in current UI surfaces and state accents.
  static const Color softYellow = Color(0xFFFFF5CC);
  static const Color softRed = Color(0xFFFDE8E8);
  static const Color softBlue = Color(0xFFD6E3FF);
  static const Color softGreen = Color(0xFF6BCB77);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color lavender = Color(0xFFB388FF);
  static const Color warmStone = Color(0xFFE8E3DA);
  static const Color warmSurface = Color(0xFFEEE9E0);
  static const Color neutralLight = Color(0xFFEBEBEB);
  static const Color neutral = Color(0xFFE0E0E0);
  static const Color pureBlack = Color(0xFF000000);
  static const Color materialGreen = Colors.green;
  static const Color materialGreenAccent = Colors.greenAccent;
  static const Color materialGrey = Colors.grey;
  static const Color transparent = Colors.transparent;
  static const Color white30 = Colors.white30;
  static const Color white70 = Colors.white70;

  // Backward-compatible aliases used throughout the existing codebase.
  static const Color primary = ink;
  static const Color accentYellow = yellow;
  static const Color accentRed = red;
  static const Color accentBlue = blue;
  static const Color accentGreen = green;
  static const Color accentPurple = purple;
  static const Color onRed = paper;
  static const Color onBlue = paper;
  static const Color onPrimary = paper;
  static const Color onAccentDefault = primary;
  static const Color background = canvas;
  static const Color surface = canvas;
  static const double frameWidth = AppStroke.regular;
  static const double hairlineWidth = AppStroke.thin;
  static const double hardShadowDepth = 3.0;
  static const Offset hardShadowOffset = Offset(3, 3);
  static const EdgeInsets hardShadowClearance = EdgeInsets.only(
    right: hardShadowDepth,
    bottom: hardShadowDepth,
  );
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: AppSpace.pageX,
    vertical: AppSpace.pageY,
  );

  // Typography scale collected from the current UI. Keep text sizes routed
  // through this set so future layout tuning can happen from one place.
  static const AppTypeScale type = AppTypeScale();
  static const AppLineHeight lineHeight = AppLineHeight();
  static const AppTracking tracking = AppTracking();

  // Layout spacing collected from current padding, gaps, and frame distances.
  static const AppSpace space = AppSpace();
  static const AppStroke stroke = AppStroke();
  static const AppBreakpoints breakpoints = AppBreakpoints();

  static TextStyle textStyle({
    double size = AppTypeScale.body,
    FontWeight weight = FontWeight.w700,
    double height = AppLineHeight.normal,
    double tracking = AppTracking.none,
    Color color = primary,
    String fontFamily = 'Space Grotesk',
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: tracking,
      color: color,
    );
  }

  static EdgeInsets insetAll(double value) => EdgeInsets.all(value);

  static EdgeInsets insetSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets insetOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }

  static Color onAccent(Color background) {
    return switch (background) {
      accentRed => onRed,
      accentBlue => onBlue,
      primary => onPrimary,
      _ => onAccentDefault,
    };
  }

  static BoxDecoration neoFrame({
    Color color = surface,
    double width = frameWidth,
    bool shadow = false,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: primary, width: width),
      boxShadow: shadow
          ? const [BoxShadow(color: primary, offset: hardShadowOffset)]
          : null,
    );
  }

  static InputDecoration neoInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: primary.withValues(alpha: 0.45),
        fontFamily: 'Space Grotesk',
        fontWeight: FontWeight.w700,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: frameWidth),
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: frameWidth),
        borderRadius: BorderRadius.zero,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: frameWidth),
        borderRadius: BorderRadius.zero,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpace.sectionGap,
        vertical: AppSpace.sectionGap,
      ),
      isDense: true,
    );
  }

  // Shared layout constants ??tuned for 390px mobile screen
  static const double navBarHeight = AppSpace.navHeight;
  static const double navBarBottomPadding = AppSpace.sectionGap;
  static const double navIconSize = AppTypeScale.titleLarge;
  static const double navActiveSize = AppTypeScale.display + 3;
  static const double navInactiveSize = AppTypeScale.pageTitleSmall + 5;
  static const double appBarHeight = 52.0;
  static const double appBarDividerHeight = AppStroke.appBarDivider;

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accentYellow,
        error: accentRed,
        surface: surface,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          color: primary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          color: primary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          color: primary,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          color: primary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          color: primary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          color: primary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          color: primary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          color: primary,
        ),
      ),
    );
  }
}

class AppTypeScale {
  const AppTypeScale();

  static const double micro = 8;
  static const double tiny = 9;
  static const double caption = 10;
  static const double small = 11;
  static const double meta = 12;
  static const double label = 13;
  static const double body = 14;
  static const double bodyLarge = 15;
  static const double subtitle = 16;
  static const double button = 17;
  static const double buttonLarge = 18;
  static const double titleSmall = 19;
  static const double title = 20;
  static const double titleLarge = 21;
  static const double section = 22;
  static const double sectionLarge = 24;
  static const double pageTitleSmall = 26;
  static const double pageTitle = 29;
  static const double displaySmall = 31;
  static const double display = 33;
  static const double displayAlt = 34;
  static const double displayLarge = 35;
  static const double hero = 37;
  static const double heroLarge = 41;
  static const double jumbo = 47;
}

class AppLineHeight {
  const AppLineHeight();

  static const double compact = 0.86;
  static const double tight = 0.94;
  static const double title = 0.98;
  static const double snug = 1.03;
  static const double readableTight = 1.12;
  static const double relaxed = 1.28;
  static const double normal = 1.36;
  static const double loose = 1.45;
  static const double doubleLine = 1.75;
}

class AppTracking {
  const AppTracking();

  static const double compressed = -1.2;
  static const double tight = -0.75;
  static const double none = 0;
  static const double wide = 0.25;
  static const double wider = 0.5;
}

class AppSpace {
  const AppSpace();

  static const double none = 0;
  static const double hair = 1;
  static const double xxs = 2;
  static const double xs = 3;
  static const double sm = 4;
  static const double md = 5;
  static const double md2 = 6;
  static const double inputGap = 7;
  static const double base = 8;
  static const double compact = 10;
  static const double sectionGap = 12;
  static const double cardGap = 14;
  static const double regular = 16;
  static const double regularPlus = 18;
  static const double large = 20;
  static const double pageX = 15;
  static const double xl = 24;
  static const double pageY = 28;
  static const double xxl = 32;
  static const double huge = 40;
  static const double inputHeight = 40;
  static const double heroGap = 48;
  static const double navHeight = 56;
  static const double controlTall = 60;
  static const double formPreview = 92;
  static const double imageThumb = 100;
  static const double textarea = 140;
  static const double formHero = 158;
  static const double mediaShort = 180;
  static const double media = 200;
  static const double mediaTall = 220;
}

class AppStroke {
  const AppStroke();

  static const double hairline = 0.75;
  static const double thin = 1.0;
  static const double regular = 1.5;
  static const double heavy = 2.0;
  static const double bold = 2.25;
  static const double appBarDivider = 3.0;
  static const double accent = 4.0;
}

enum AppScreenClass { mobile, tablet, desktop }

class AppBreakpoints {
  const AppBreakpoints();

  static const double mobileMax = 600;
  static const double tabletMax = 1024;
  static const double mobileFrame = 390;
  static const double tabletFrame = 768;
  static const double desktopFrame = 1180;
  static const double desktopMargin = 32;

  static AppScreenClass screenClassFor(double width) {
    if (width < mobileMax) {
      return AppScreenClass.mobile;
    }
    if (width < tabletMax) {
      return AppScreenClass.tablet;
    }
    return AppScreenClass.desktop;
  }

  static bool isMobile(BuildContext context) {
    return screenClassFor(MediaQuery.sizeOf(context).width) ==
        AppScreenClass.mobile;
  }

  static bool isTablet(BuildContext context) {
    return screenClassFor(MediaQuery.sizeOf(context).width) ==
        AppScreenClass.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return screenClassFor(MediaQuery.sizeOf(context).width) ==
        AppScreenClass.desktop;
  }

  static double appFrameWidthFor(double width) {
    final screenClass = screenClassFor(width);
    switch (screenClass) {
      case AppScreenClass.mobile:
        return width < mobileFrame ? width : mobileFrame;
      case AppScreenClass.tablet:
        return width < tabletFrame ? width : tabletFrame;
      case AppScreenClass.desktop:
        final availableWidth = width - (desktopMargin * 2);
        return availableWidth < desktopFrame ? availableWidth : desktopFrame;
    }
  }

  static double contentMaxWidthFor(double width) {
    final screenClass = screenClassFor(width);
    switch (screenClass) {
      case AppScreenClass.mobile:
        return mobileFrame;
      case AppScreenClass.tablet:
        return 640;
      case AppScreenClass.desktop:
        return 920;
    }
  }
}

class NeoPageScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final String? activeRoute;
  final bool showNavigation;
  final bool centerContent;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;

  const NeoPageScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.activeRoute,
    this.showNavigation = false,
    this.centerContent = false,
    this.padding,
    this.backgroundColor = AppTheme.background,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final screenClass = AppBreakpoints.screenClassFor(width);
    final effectiveBody = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: centerContent
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppBreakpoints.contentMaxWidthFor(width),
                ),
                child: body,
              ),
            )
          : body,
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: effectiveBody,
      bottomNavigationBar:
          showNavigation &&
              activeRoute != null &&
              screenClass == AppScreenClass.mobile
          ? ObscureNavBar(pageContext: context, activeRoute: activeRoute!)
          : null,
    );
  }
}

class NeoBoxDecoration extends BoxDecoration {
  const NeoBoxDecoration({
    Color color = AppTheme.surface,
    bool isAction = false,
  }) : super(
         color: color,
         border: const Border.fromBorderSide(
           BorderSide(color: AppTheme.primary, width: AppStroke.regular),
         ),
         boxShadow: const [
           BoxShadow(
             color: AppTheme.primary,
             offset: AppTheme.hardShadowOffset,
             blurRadius: 0,
             spreadRadius: 0,
           ),
         ],
       );
}

/// Shared bottom navigation bar used across all main screens.
class ObscureNavBar extends StatelessWidget {
  final BuildContext pageContext;
  final String activeRoute;

  const ObscureNavBar({
    super.key,
    required this.pageContext,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDesignerSurface = {
      '/daily_planner',
      '/designer_profile',
      '/income_dashboard',
      '/portfolio_management',
      '/new_work',
    }.contains(activeRoute);
    final homeRoute = isDesignerSurface ? '/daily_planner' : '/discovery_feed';

    final items = [
      ('home', homeRoute),
      ('search', '/search_categories'),
      ('shining', '/commission_status'),
      ('chat', '/message_inbox'),
      ('user', '/designer_profile'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: AppTheme.navBarBottomPadding,
          top: 4,
        ),
        child: Container(
          height: AppTheme.navBarHeight,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.primary, width: AppStroke.heavy),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.primary,
                offset: AppTheme.hardShadowOffset,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.map((item) {
              final isActive = item.$2 == activeRoute;
              return GestureDetector(
                onTap: () {
                  if (!isActive) {
                    Navigator.pushReplacementNamed(pageContext, item.$2);
                  }
                },
                child: Container(
                  width: isActive
                      ? AppTheme.navActiveSize
                      : AppTheme.navInactiveSize,
                  height: isActive
                      ? AppTheme.navActiveSize
                      : AppTheme.navInactiveSize,
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.accentYellow : AppTheme.surface,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: AppIcons.fromName(
                    item.$1,
                    color: AppTheme.primary,
                    size: AppTheme.navIconSize,
                    isActive: isActive,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// A shared AppBar widget with centered Obscure logo.
class ObscureAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;

  const ObscureAppBar({super.key, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(
    AppTheme.appBarHeight + AppTheme.appBarDividerHeight,
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppTheme.appBarHeight,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 10, height: 20, color: AppTheme.primary),
          const SizedBox(width: 4),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.primary,
                  width: AppStroke.regular,
                ),
              ),
            ),
            padding: const EdgeInsets.only(top: 2),
            child: const Text(
              'Obscure',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppTheme.primary,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: AppTheme.background,
      elevation: 0,
      leading:
          leading ??
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              icon: AppIcons.equal(color: AppTheme.primary, size: 22),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/settings') {
                  Navigator.pushNamed(context, '/settings');
                }
              },
            ),
          ),
      actions:
          actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: AppIcons.notification(color: AppTheme.primary, size: 22),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    FadeSlideRoute(
                      page: const NotificationCenterScreen(),
                      settings: const RouteSettings(name: '/notifications'),
                    ),
                  );
                },
              ),
            ),
          ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppTheme.appBarDividerHeight),
        child: Container(
          color: AppTheme.primary,
          height: AppTheme.appBarDividerHeight,
        ),
      ),
    );
  }
}
