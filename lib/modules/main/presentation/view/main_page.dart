import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart'
    show AgentState, AgentLoading;
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_viewmodel.dart' show AgentViewmodel;
import 'package:ai_operator_app/modules/main/presentation/view/components/main_agent_floating_button.dart';
import 'package:ai_operator_app/modules/main/presentation/view/components/main_agent_result_snackbar.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab returns it to its root page.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainAgentResultSnackBarListener(
      child: Scaffold(
        body: navigationShell,
        floatingActionButton: BlocBuilder<AgentViewmodel, AgentState>(
          builder: (context, state) {
            return MainAgentFloatingButton(
              isAgentLoading: state is AgentLoading,
              onMessageSubmitted: context.read<AgentViewmodel>().sendMessage,
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
          height: AppSizes.bottomNavHeight,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: AppStrings.homeTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: AppStrings.profileTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: AppStrings.settingsTitle,
            ),
          ],
        ),
      ),
    );
  }
}
