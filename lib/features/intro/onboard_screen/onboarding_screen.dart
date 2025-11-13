// lib/feature/onboarding_screen/onboarding_screen.dart
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Numerous Free Trial Courses",
      "subtitle": "Free courses for you to find your way to learning",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Quick and Easy Learning",
      "subtitle":
          "Easy and fast learning at any time to help you improve various skills",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Create Your Own Study Plan",
      "subtitle":
          "Study according to the study plan, make study more motivated",
    },
  ];

  void _navigateToNext() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigation.pushNamedandRemoveUntilTo(context, Routes.welcome);
    }
  }

  void _skipOnboarding() {
    Navigation.pushNamedandRemoveUntilTo(context, Routes.welcome);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(reverse: true,allowImplicitScrolling: true,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Image.asset(
                          onboardingData[index]['image']!,
                          height: 300,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: AppColors.gryColor,
                              child: const Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        Gap(40),
                        Text(
                          onboardingData[index]['title']!,
                          style: TextStyles.textStyle24.copyWith(
                            fontWeight: FontWeight.bold,
                          ),

                          textAlign: TextAlign.center,
                        ),
                        Gap(16),
                        Text(
                          textAlign: TextAlign.center,

                          onboardingData[index]['subtitle']!,
                          style: TextStyles.textStyle16.copyWith(
                            color: AppColors.darkgrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  "SKIP",
                  style: TextStyles.textStyle16.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : AppColors.mediumGray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text("BACK", style: TextStyles.textStyle16),
                          ),

                        const Spacer(),

                        ElevatedButton(
                          onPressed: _navigateToNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            _currentPage == onboardingData.length - 1
                                ? "GET STARTED"
                                : "NEXT",
                            style: TextStyles.textStyle16.copyWith(
                              color: AppColors.backGroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
