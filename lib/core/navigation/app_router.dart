import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/core/navigation/main_shell_scaffold.dart';
import 'package:ai_operator_app/modules/agent/presentation/view/agent_page.dart';
import 'package:ai_operator_app/modules/home/presentation/home_page.dart';
import 'package:ai_operator_app/modules/profile/presentation/profile_page.dart';
import 'package:ai_operator_app/modules/settings/presentation/settings_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    // Outside the shell so the chat is full screen with no bottom nav.
    GoRoute(
      path: AppRoutes.agent,
      builder: (context, state) => const AgentPage(),
    ),
  ],
);
