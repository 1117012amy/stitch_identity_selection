// ignore_for_file: unused_field

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/app_text.dart';
import 'core/fade_slide_route.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/customer/customer_profile_screen.dart';
import 'screens/customer/customer_signup_screen.dart';
import 'screens/customer/discovery_feed_screen.dart';
import 'screens/customer/search_categories_screen.dart';
import 'screens/designer/daily_planner_screen.dart';
import 'screens/designer/designer_profile_screen.dart';
import 'screens/designer/designer_signup_screen.dart';
import 'screens/designer/income_dashboard_screen.dart';
import 'screens/designer/new_work_screen.dart';
import 'screens/designer/portfolio_management_screen.dart';
import 'screens/shared/commission_status_screen.dart';
import 'screens/shared/contract_quote_screen.dart';
import 'screens/shared/identity_selection_screen.dart';
import 'screens/shared/login_verification_screen.dart';
import 'screens/shared/message_inbox_screen.dart';
import 'screens/shared/notification_center_screen.dart';
import 'screens/shared/project_screen.dart';
import 'screens/shared/review_rating_screen.dart';
import 'screens/shared/settings_screen.dart';
import 'screens/shared/view_orders_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.loadDesignerProjects();
  runApp(const StitchApp());
}

class StitchApp extends StatefulWidget {
  const StitchApp({super.key});

  static const Map<String, String> screenLabels = {
    '/message_inbox': AppText.screenMessageInbox,
    '/contract_quote': AppText.screenContractQuote,
    '/settings': AppText.screenSettings,
  };

  static const Map<String, String> componentLabels = {
    'folder_project_card.dart': AppText.componentIcon,
  };

  @override
  State<StitchApp> createState() => _StitchAppState();
}

class _StitchAppState extends State<StitchApp> {
  int _refreshTick = 0;

  static const Map<String, String> screenLabels = {
    '/message_inbox': AppText.screenMessageInbox,
    '/contract_quote': AppText.screenContractQuote,
    '/settings': AppText.screenSettings,
  };

  static const Map<String, String> componentLabels = {
    'folder_project_card.dart': AppText.componentIcon,
  };

  static final Map<String, WidgetBuilder> _screens = {
    '/': (context) => const LoginVerificationScreen(),
    '/identity_selection': (context) => const IdentitySelectionScreen(),
    '/customer_signup': (context) => const CustomerSignupScreen(),
    '/customer_profile': (context) => const CustomerProfileScreen(),
    '/daily_planner': (context) => const DailyPlannerScreen(),
    '/designer_profile': (context) => const DesignerProfileScreen(),
    '/designer_signup': (context) => const DesignerSignupScreen(),
    '/discovery_feed': (context) => const DiscoveryFeedScreen(),
    '/commission_status': (context) => const CommissionStatusScreen(),
    '/income_dashboard': (context) => const IncomeDashboardScreen(),
    '/message_inbox': (context) => const MessageInboxScreen(),
    '/portfolio_management': (context) => const PortfolioManagementScreen(),
    '/search_categories': (context) => const SearchCategoriesScreen(),
    '/notifications': (context) => const NotificationCenterScreen(),
    '/contract_quote': (context) => const ContractQuoteScreen(),
    '/review_rating': (context) => const ReviewRatingScreen(),
    '/admin_dashboard': (context) => const AdminDashboardScreen(),
    '/new_work': (context) => const NewWorkScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/project': (context) => const ProjectScreen(),
    '/view_orders': (context) => const ViewOrdersScreen(),
  };

  static const Set<String> _designerOnlyRoutes = {
    '/daily_planner',
    '/designer_profile',
    '/income_dashboard',
    '/portfolio_management',
    '/new_work',
  };

  static String _guardedRouteName(String? routeName) {
    final name = routeName ?? '/';
    if (AppTheme.isDesigner && name == '/discovery_feed') {
      return '/daily_planner';
    }
    // 設計師不使用客戶個人頁，改導向設計師個人頁
    if (AppTheme.isDesigner && name == '/customer_profile') {
      return '/designer_profile';
    }
    if (_designerOnlyRoutes.contains(name) && !AppTheme.isDesigner) {
      return '/discovery_feed';
    }
    return name;
  }

  Future<void> _refreshCurrentSurface() async {
    await AppTheme.loadDesignerProjects();
    setState(() {
      _refreshTick++;
    });
    await Future<void>.delayed(const Duration(milliseconds: 240));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBSCURE',
      theme: AppTheme.lightTheme,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final guardedName = _guardedRouteName(settings.name);
        final builder = _screens[guardedName];
        if (builder != null) {
          return FadeSlideRoute(
            page: Builder(builder: builder),
            settings: RouteSettings(
              name: guardedName,
              arguments: settings.arguments,
            ),
          );
        }
        return FadeSlideRoute(
          page: const LoginVerificationScreen(),
          settings: settings,
        );
      },
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final frameWidth = AppBreakpoints.appFrameWidthFor(
              constraints.maxWidth,
            );

            return Container(
              color: AppTheme.primary,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: frameWidth),
                  child: RefreshIndicator(
                    key: ValueKey(_refreshTick),
                    color: AppTheme.primary,
                    backgroundColor: AppTheme.paper,
                    strokeWidth: 2,
                    notificationPredicate: (notification) =>
                        notification.metrics.axis == Axis.vertical,
                    onRefresh: _refreshCurrentSurface,
                    child: ClipRect(child: child!),
                  ),
                ),
              ),
            );
          },
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
