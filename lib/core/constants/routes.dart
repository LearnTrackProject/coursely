import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/features/auth/data/models/user_type_enum.dart';
import 'package:coursely/features/auth/presentation/page/completed_registeration_screen.dart';
import 'package:coursely/features/auth/presentation/page/login_with_phone.dart';
import 'package:coursely/features/auth/presentation/page/login_screen.dart';
import 'package:coursely/features/auth/presentation/page/register_screen.dart';
import 'package:coursely/features/auth/presentation/page/verify_phone_screen.dart';
import 'package:coursely/features/course_details/screens/course_detail_screen.dart';
import 'package:coursely/features/main_screen/main_screen.dart';
import 'package:coursely/features/intro/onboard_screen/onboarding_screen.dart';
import 'package:coursely/features/intro/splash_screen/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:coursely/features/welcome/welcome_screen.dart';

class Routes {
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = "/onboard_screen";
  static const String phoneLogin = "/forgetpassword_screen";
  static const String registerScreen = "/register_screen";
  static const String loginScreen = "/login_screen";
  static const String mainScreen = "/main_Screen";
  static const String welcome = "/welcome";
  static const String courseDetailScreen = "/coursedetail_Screen";
  static const String verifyPhoneScreen = "/verifyPhone_Screen";
  static const String completeRegisterScreen = "/completeRegister_Screen";

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
        path: completeRegisterScreen,
        builder: (context, state) {
          return CompletedRegisterationScreen();
        },
      ),
      GoRoute(
        path: mainScreen,
        builder: (context, state) {
          return MainScreen();
        },
      ),
      GoRoute(
        path: verifyPhoneScreen,
        builder: (context, state) {
          return VerifyPhoneScreen();
        },
      ),
      GoRoute(
        path: courseDetailScreen,

        builder: (context, state) {
          // var items = state.extra as Map<String, dynamic>;

          return CourseDetailScreen(
            heroTag: "1",
            imageUrl: AppImages.image5,
            price: 150,
            title: "h1",
          );
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
        path: phoneLogin,
        builder: (context, state) {
          return PhoneLoginScreen();
        },
      ),
      GoRoute(
        path: loginScreen,
        builder: (context, state) {
          return LoginScreen(userType: state.extra as UserTypeEnum);
        },
      ),

      GoRoute(
        path: welcome,
        builder: (context, state) {
          return WelcomeScreen();
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
