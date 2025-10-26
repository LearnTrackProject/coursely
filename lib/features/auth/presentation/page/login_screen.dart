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
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 60)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Log In',
                  style: TextStyles.textStyle32.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      // height: 600,
                      decoration: BoxDecoration(
                        color: AppColors.backGroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
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
                                    Routes.phoneLogin,
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
                            MainButton(onPressed: () {}, text: 'Log In'),
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
                                      Routes.register,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
