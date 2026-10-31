import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/modules/agent/presentation/view/agent_page.dart';
import 'package:ai_operator_app/modules/home/presentation/home_page.dart';
import 'package:ai_operator_app/modules/profile/presentation/profile_page.dart';
import 'package:ai_operator_app/modules/settings/presentation/settings_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.agent,
      builder: (context, state) => const AgentPage(),
    ),
  ],
);