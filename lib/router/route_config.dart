import 'package:go_router/go_router.dart';
import 'package:picacg/pages/login/login_page.dart';
import 'package:picacg/pages/main/main_page.dart';
import 'package:picacg/provider/config_provider.dart';

class RouteConfig {
  static const String main = '/';
  static const String login = '/login';

  static final GoRouter _router = GoRouter(
    initialLocation: login,
    routes: <RouteBase>[
      GoRoute(
        path: main,
        builder: (context, state) {
          return const MainPage();
        },
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
    ],
    redirect: (context, state) async {
      final isAuthenticated = globalConfig.userData.token.isEmpty;

      if (isAuthenticated && state.path != login) {
        return login;
      } else {
        return null;
      }
    },
  );

  static GoRouter get router => _router;
}
