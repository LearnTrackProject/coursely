import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:coursely/features/auth/data/models/user_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserTypeEnum? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              Text(
                'Who Are You?',
                style: TextStyles.textStyle24.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Please tell us a little bit more about yourself and who you are?',
                style: TextStyles.textStyle15.copyWith(
                  color: AppColors.gryColor,
                ),
              ),
              Gap(15),
              Text(
                'Login As',
                style: TextStyles.textStyle24.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(20),
              _buildOptionCard(
                role: UserTypeEnum.student,
                onTap: () {
                  selectedRole = UserTypeEnum.student;
                },
                title: 'Student',
                description: 'You are joining our platform to learn things!',
                imagePath: AppImages.student,
              ),
              Gap(20),
              _buildOptionCard(
                role: UserTypeEnum.teacher,
                onTap: () {
                  selectedRole = UserTypeEnum.teacher;
                },
                title: 'Teacher',
                description: 'You are joining our platform to teach things!',
                imagePath: AppImages.teacher,
              ),
              const Spacer(),
              MainButton(
                text: 'Continue',
                onPressed: selectedRole == null
                    ? () {}
                    : () {
                        if (selectedRole == UserTypeEnum.student) {
                          Navigation.pushReplacementNamed(
                            context,
                            Routes.loginScreen,
                            selectedRole,
                          );
                        } else if (selectedRole == UserTypeEnum.teacher) {
                          Navigation.pushNamedTo(
                            context,
                            Routes.loginScreen,
                            selectedRole,
                          );
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required String imagePath,
    required Function() onTap,
    required UserTypeEnum role,
  }) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        onTap();
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlue : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.borderColor : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.secondaryColor
                          : Colors.black87,
                    ),
                  ),
                  Gap(4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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
