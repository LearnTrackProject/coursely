import 'package:coursely/features/auth/presentation/page/forget_password_screen.dart';
import 'package:coursely/features/auth/presentation/page/login_screen.dart';
import 'package:coursely/features/auth/presentation/page/register_screen.dart';
import 'package:coursely/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splash = '/';
  // static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/ForgetPassword';


  static final routes = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: login,
        builder: (context, state) =>  LoginScreen(),
      ),
      GoRoute(
        path: forgetPassword,
        builder: (context, state) =>  ForgetPasswordScreen(),
      ),GoRoute(
        path: register,
        builder: (context, state) =>  RegisterScreen(),
      ),
    ],
  );
}
