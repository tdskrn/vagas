import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:vagas/app/core/pages/auth/login_page.dart';
import 'package:vagas/app/core/pages/home_page.dart';
import 'package:vagas/app/core/router/auth_manager.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final authManager = AuthManager(auth: auth);

final appRouter = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) async {
      final isGoingTo = state.fullPath;
      final isAuth = await authManager.isAuthenticated();
      if (!isAuth && (isGoingTo != '/login-page' && isGoingTo != '/')) {
        return '/login-page';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: LoginPage.name,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/login-page',
        name: "LoginPage",
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/home-page',
        name: HomePage.name,
        builder: (context, state) => HomePage(),
      )
    ]);
