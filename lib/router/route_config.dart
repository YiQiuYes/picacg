import 'package:go_router/go_router.dart';
import 'package:picacg/pages/main_page.dart';

class RouteConfig {
  static const String main = '/';

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: main,
        builder: (context, state) {
          return const MainPage();
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
