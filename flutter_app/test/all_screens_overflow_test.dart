import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:obscure_app/core/app_theme.dart';
import 'package:obscure_app/screens/admin/admin_dashboard_screen.dart';
import 'package:obscure_app/screens/customer/customer_profile_screen.dart';
import 'package:obscure_app/screens/customer/customer_signup_screen.dart';
import 'package:obscure_app/screens/customer/discovery_feed_screen.dart';
import 'package:obscure_app/screens/customer/search_categories_screen.dart';
import 'package:obscure_app/screens/designer/daily_planner_screen.dart';
import 'package:obscure_app/screens/designer/designer_profile_screen.dart';
import 'package:obscure_app/screens/designer/designer_signup_screen.dart';
import 'package:obscure_app/screens/designer/income_dashboard_screen.dart';
import 'package:obscure_app/screens/designer/new_work_screen.dart';
import 'package:obscure_app/screens/designer/portfolio_management_screen.dart';
import 'package:obscure_app/screens/shared/commission_status_screen.dart';
import 'package:obscure_app/screens/shared/contract_quote_screen.dart';
import 'package:obscure_app/screens/shared/identity_selection_screen.dart';
import 'package:obscure_app/screens/shared/login_verification_screen.dart';
import 'package:obscure_app/screens/shared/message_inbox_screen.dart';
import 'package:obscure_app/screens/shared/notification_center_screen.dart';
import 'package:obscure_app/screens/shared/project_detail_screen.dart';
import 'package:obscure_app/screens/shared/project_screen.dart';
import 'package:obscure_app/screens/shared/review_rating_screen.dart';
import 'package:obscure_app/screens/shared/settings_screen.dart';
import 'package:obscure_app/screens/shared/view_orders_screen.dart';

void main() {
  final screens = <String, Widget Function()>{
    '/': () => const LoginVerificationScreen(),
    '/identity_selection': () => const IdentitySelectionScreen(),
    '/customer_signup': () => const CustomerSignupScreen(),
    '/customer_profile': () => const CustomerProfileScreen(),
    '/daily_planner': () => const DailyPlannerScreen(),
    '/designer_profile': () => const DesignerProfileScreen(),
    '/designer_signup': () => const DesignerSignupScreen(),
    '/discovery_feed': () => const DiscoveryFeedScreen(),
    '/commission_status': () => const CommissionStatusScreen(),
    '/income_dashboard': () => const IncomeDashboardScreen(),
    '/message_inbox': () => const MessageInboxScreen(),
    '/portfolio_management': () => const PortfolioManagementScreen(),
    '/search_categories': () => const SearchCategoriesScreen(),
    '/notifications': () => const NotificationCenterScreen(),
    '/contract_quote': () => const ContractQuoteScreen(),
    '/review_rating': () => const ReviewRatingScreen(),
    '/admin_dashboard': () => const AdminDashboardScreen(),
    '/new_work': () => const NewWorkScreen(),
    '/settings': () => const SettingsScreen(),
    '/project': () => const ProjectScreen(),
    '/project_detail': () => const ProjectDetailScreen(),
    '/view_orders': () => const ViewOrdersScreen(),
  };

  testWidgets('Scan all screens at 390x844 for overflow errors', (tester) async {
    final errorsByRoute = <String, List<String>>{};
    final originalOnError = FlutterError.onError;

    for (final entry in screens.entries) {
      final isDesignerRoute = const {
        '/daily_planner',
        '/designer_profile',
        '/designer_signup',
        '/income_dashboard',
        '/portfolio_management',
        '/new_work',
      }.contains(entry.key);
      AppTheme.isDesigner = isDesignerRoute;

      final captured = <String>[];
      FlutterError.onError = (FlutterErrorDetails details) {
        captured.add(details.exceptionAsString());
      };

      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: entry.value(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      if (captured.isNotEmpty) {
        errorsByRoute[entry.key] = captured;
      }
    }

    FlutterError.onError = originalOnError;
    addTearDown(tester.view.reset);

    if (errorsByRoute.isNotEmpty) {
      final report = errorsByRoute.entries
          .map((e) => '${e.key}:\n  - ${e.value.join("\n  - ")}')
          .join('\n');
      fail('Overflow/Layout errors found:\n$report');
    }
  });
}
