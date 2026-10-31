import 'package:go_router/go_router.dart';

class AppRouterContext {
  final GoRouter router;

  AppRouterContext(this.router);

  /// Current active navigation stack.
  String currentStack() {
    return router.routerDelegate.currentConfiguration.matches
        .map((m) => m.matchedLocation)
        .join(' → ');
  }

  /// Complete configured route tree.
  String routeTree() {
    String build(List<RouteBase> routes) {
      return routes.map((route) {
        final path = route is GoRoute
            ? route.path
            : route.runtimeType.toString();

        final children = route is StatefulShellRoute
            ? route.branches.expand((b) => b.routes).toList()
            : route.routes;

        return children.isEmpty
            ? path
            : '$path { ${build(children)} }';
      }).join(', ');
    }

    return build(router.configuration.routes);
  }

  String getRouterContext() {
    return '\n Current stack: $currentStack() \n Route tree: $routeTree() \n';
  }
}