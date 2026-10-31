# Main Navigation

## Purpose

The app shows a bottom navigation bar with Home, Profile, and Settings tabs. The tabs are a go_router `StatefulShellRoute`, so each tab's widget tree stays mounted when you switch away from it. The Agent screen is a full-screen route outside the shell, so it has no bottom nav bar.

## Entry Points

- Router: `lib/core/navigation/app_router.dart`
- Shell UI: `lib/core/navigation/main_shell_scaffold.dart`
- Home screen, which opens the agent: `lib/modules/home/presentation/home_page.dart`
- Route paths: `lib/core/navigation/app_routes.dart`

## Flow

1. `MaterialApp.router` in `lib/main.dart` uses `appRouter`.
2. `appRouter` declares a `StatefulShellRoute.indexedStack` with three branches: `/`, `/profile`, and `/settings`. Its builder wraps them in `MainShellScaffold`.
3. `MainShellScaffold` renders a `NavigationBar`. A tap calls `goBranch(index, initialLocation: index == currentIndex)`, so tapping the active tab returns it to its root page.
4. `/agent` is a top-level `GoRoute` outside the shell. `HomePage` pushes it with `context.push`, which covers the shell and hides the nav bar.
5. AI navigation (`NavigateUseCase`) uses the same `appRouter`, so `go('/profile')` selects the Profile tab.

## Important Files

- `app_router.dart` - owns the route tree and branch order.
- `main_shell_scaffold.dart` - owns the tab bar and branch switching. Holds no state; the selected index comes from the shell.
- `home_page.dart` - home layout; pushes `/agent`.
- `home_welcome_section.dart` - vertical welcome card.
- `home_destination_card.dart` - Agent entry card.
- `lib/core/ai/helpers/app_router_context.dart` - describes the route tree to the AI and already walks shell branches.

## Dependencies

- Tokens: `AppSizes.bottomNavHeight`.
- Strings: `AppStrings.homeTitle`, `AppStrings.profileTitle`, `AppStrings.settingsTitle`.
- AI route list: `AIFunctionsDefinitionsList` in `lib/shared/ai/ai_functions_definitions_list.dart`.
- No storage, network, or domain changes.

## Common Changes

- **Add a tab:** add a `StatefulShellBranch` in `app_router.dart`, add a `NavigationDestination` in the same position in `main_shell_scaffold.dart`, add the path to `AppRoutes` and to `AppRoutes.tabs` (in branch order), and add it to `_routePaths` in `AIFunctionsDefinitionsList` so the AI can open it. Then update the navigation tests.
- **Make a screen full screen (no nav bar):** declare its `GoRoute` at the top level, outside the `StatefulShellRoute`.
- **Keep branch order and destination order in sync:** index 0 is Home, 1 is Profile, 2 is Settings.

## Edge Cases

- **Never push or replace onto a tab:** a tab lives in the shell, and the shell's page key is derived from the route object. Pushing a tab route on top of a page that was itself pushed (for example, the agent opened from Home) puts the shell's key on the stack twice and throws `!keyReservation.contains(key)`. `NavigateUseCase` sends tab targets through `go` for this reason. `go` and `replace` were also checked; `go` is safe, and `replace` from the agent is safe because the agent leaves the stack. Keep this in mind for any new push call.
- **Profile name stays in sync:** `WatchProfileNameUseCase` exposes `UserPreferencesRepository.watchProfileName()`. `ProfileViewModel` subscribes for the life of the tab.
- **Dark mode stays in sync:** `WatchDarkModeUseCase` exposes `UserPreferencesRepository.watchDarkModeEnabled()`. `SettingsViewModel` subscribes the same way. `SetDarkModeUseCase` still updates `appThemeMode` when the value is saved.
- **Agent back behavior:** the agent route sits on the root navigator, so Back returns to the tab that was open.
- **AI `go('/agent')`:** replaces the whole stack, so the agent page has no back button. This predates the shell.

## Testing

- Widget tests: `test/core/navigation/main_shell_navigation_test.dart` covers the three tabs, tab switching, the home contents, and router-driven tab selection.
- Use-case tests: `test/core/domain/usecases/navigate_usecase_test.dart` covers pushing a tab while the agent is open (the crash above) and pushing a normal route. These use a stub router with the same shape, because the real agent page needs Gemini initialized.
- Run with `flutter test test/core/navigation test/core/domain`.
- Manual check:
  - Switch tabs and confirm each tab keeps its state.
  - Open Agent from Home and confirm there is no nav bar.
  - Press Back from Agent and confirm you return to Home.
  - Ask the agent to open Profile and confirm the Profile tab is selected.

## Notes

- The "Go to home" buttons on Profile and Settings were removed because the nav bar replaces them.
- `AppRoutes` is the single source of route path strings, and the AI route list reads from it.
