import 'package:coursely/features/auth/presentation/page/forget_password_screen.dart';
import 'package:coursely/features/auth/presentation/page/login_screen.dart';
import 'package:coursely/features/auth/presentation/page/register_screen.dart';
import 'package:coursely/features/main_screen/main_screen.dart';
import 'package:coursely/features/onboard_screen/onboarding_screen.dart';
import 'package:coursely/features/splash_screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = "/onboard_screen";
  static const String forgetPasswordScreen = "/forgetpassword_screen";
  static const String registerScreen = "/register_screen";
  static const String loginScreen = "/login_screen";
  static const String mainScreen = "/main_Screen";
  static var routes = GoRouter(
    initialLocation: splashScreen,
    routes: [
      GoRoute(
        path: mainScreen,
        builder: (context, state) {
          return MainScreen();
        },
      ),
      GoRoute(
        path: splashScreen,
        builder: (context, state) {
          return SplashScreen();
        },
      ),
      GoRoute(
        path: onboardScreen,
        builder: (context, state) {
          return OnboardingScreen();
        },
      ),
      GoRoute(
        path: forgetPasswordScreen,
        builder: (context, state) {
          return ForgetPasswordScreen();
        },
      ),
      GoRoute(
        path: loginScreen,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: registerScreen,
        builder: (context, state) {
          return RegisterScreen();
        },
      ),
    ],
  );
}
