import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToOnboarding();
    });
  }

  void _navigateToOnboarding() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // context.go('/onboarding');
        Navigation.pushNamedandRemoveUntilTo(context, Routes.onboardScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splashscreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),
              const SizedBox(height: 33),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildSubtitle(),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/images/icon.png",
      width: 222,
      height: 222,
      filterQuality: FilterQuality.medium,
    );
  }

  Widget _buildTitle() {
    return Text(
      'Coursely',
      style: TextStyles.textStyle30.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: const [
          Shadow(
            blurRadius: 10,
            color: Color(0x80000000),
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Grow Your Skills, Achieve More',
      style: TextStyles.textStyle18.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        shadows: const [
          Shadow(blurRadius: 8, color: Color(0x80000000), offset: Offset(1, 1)),
        ],
      ),
    );
  }
}
