import 'package:coursely/features/auth/presentation/page/completed_registeration_screen.dart';
import 'package:coursely/features/auth/presentation/page/login_screen.dart';
import 'package:coursely/features/auth/presentation/page/phone_login_screen.dart';
import 'package:coursely/features/auth/presentation/page/register_screen.dart';
import 'package:coursely/features/auth/presentation/page/verify_phone_screen.dart';
import 'package:coursely/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splash = '/';
  // static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  // static const String forgetPassword = '/ForgetPassword';
  static const String phoneLogin = '/phoneLogin';
  static const String verifyPhone = '/verifyPhone';
  static const String completedRegister = '/completedRegister';

  static final routes = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => LoginScreen()),
      // GoRoute(
      //   path: forgetPassword,
      //   builder: (context, state) =>  ForgetPasswordScreen(),
      // ),
      GoRoute(path: register, builder: (context, state) => RegisterScreen()),
      GoRoute(
        path: phoneLogin,
        builder: (context, state) => PhoneLoginScreen(),
      ),
      GoRoute(
        path: verifyPhone,
        builder: (context, state) => verifyPhoneScreen(),
      ),
      GoRoute(
        path: completedRegister,
        builder: (context, state) => CompletedRegisterationScreen(),
      ),
    ],
  );
}
