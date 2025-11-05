// lib/feature/onboarding_screen/onboarding_screen.dart
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:flutter/material.dart';

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
            PageView.builder(
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
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Text(
                          onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]['subtitle']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // زر التخطي في الأعلى
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  "SKIP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),

            // الدوائر وأزرار التنقل في الأسفل
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // الدوائر (Slider indicator)
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
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // أزرار التنقل
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        // زر الرجوع للخلف
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              "BACK",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),

                        const Spacer(),

                        // زر التالي أو البدء
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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
