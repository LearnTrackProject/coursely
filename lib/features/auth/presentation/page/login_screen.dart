import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:coursely/core/widgets/password_text_form_field.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  // var emailController = TextEditingController();
  // var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildLoginBody());
  }
}

// ignore: camel_case_types
class _buildLoginBody extends StatelessWidget {
  const _buildLoginBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 24, left: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Log In',
                        style: TextStyles.textStyle30.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    right: 24,
                    left: 24,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Email',
                        style: TextStyles.textStyle14.copyWith(
                          color: AppColors.darkgrey,
                        ),
                      ),
                      CustomTextFormField(
                        controller: TextEditingController(),
                        hintText: 'Enter Email',
                      ),
                      Gap(25),
                      Text(
                        'Password',
                        style: TextStyles.textStyle14.copyWith(
                          color: AppColors.darkgrey,
                        ),
                      ),
                      PasswordTextFormField(
                        controller: TextEditingController(),
                        hintText: 'Enter Password',
                      ),
                      Gap(13),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigation.pushNamedTo(
                              context,
                              Routes.forgetPasswordScreen,
                            );
                          },
                          child: Text(
                            "Forget Password?",
                            style: TextStyles.textStyle14.copyWith(
                              color: AppColors.gryColor,
                            ),
                          ),
                        ),
                      ),
                      Gap(13),
                      MainButton(
                        onPressed: () {
                          Navigation.pushNamedTo(context, Routes.mainScreen);
                        },
                        text: 'Log In',
                      ),
                      Gap(26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyles.textStyle15.copyWith(
                              color: AppColors.gryColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigation.pushReplacementNamed(
                                context,
                                Routes.registerScreen,
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyles.textStyle15.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(23),
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Or login With',
                              style: TextStyles.textStyle12,
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Gap(21),
                      Row(
                        children: [
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              AppImages.googleSvg,
                              width: 36,
                            ),
                          ),
                          Gap(36),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              AppImages.facebookSvg,
                              width: 36,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
