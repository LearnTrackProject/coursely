import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:coursely/core/widgets/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(child: _BuildRegisterBody(isChecked, onCheckChanged)),
    );
  }

  void onCheckChanged(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }
}

class _BuildRegisterBody extends StatelessWidget {
  final bool isChecked;
  final Function(bool?) onCheckChanged;

  const _BuildRegisterBody(this.isChecked, this.onCheckChanged);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 30)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyles.textStyle30.copyWith(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your details below & create a free account',
                    style: TextStyles.textStyle12.copyWith(
                      color: AppColors.gryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height,
                  decoration: const BoxDecoration(
                    color: AppColors.backGroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.darkgrey,
                          ),
                        ),
                        CustomTextFormField(
                          controller: TextEditingController(),
                          hintText: 'Enter your name',
                        ),
                        const Gap(25),
                        Text(
                          'Email',
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.darkgrey,
                          ),
                        ),
                        CustomTextFormField(
                          controller: TextEditingController(),
                          hintText: 'Enter your email',
                        ),
                        const Gap(25),
                        Text(
                          'Password',
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.darkgrey,
                          ),
                        ),
                        PasswordTextFormField(
                          controller: TextEditingController(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          hintText: 'Enter password',
                        ),
                        const Gap(25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              value: isChecked,
                              onChanged: onCheckChanged,
                            ),
                            Expanded(
                              child: Text(
                                'By creating an account you agree to our Terms & Conditions.',
                                style: TextStyles.textStyle12.copyWith(
                                  color: AppColors.gryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(25),
                        MainButton(
                          text: 'Create Account',
                          onPressed: () {
                            if (!isChecked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please agree to the terms before continuing.',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigation.pushNamedandRemoveUntilTo(
                              context,
                              Routes.mainScreen,
                            );
                          },
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyles.textStyle15,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigation.pushReplacementNamed(
                                    context,
                                    Routes.loginScreen,
                                  );
                                },
                                child: Text(
                                  "Log In",
                                  style: TextStyles.textStyle15.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
