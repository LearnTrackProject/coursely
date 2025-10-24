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
  // var emailController = TextEditingController();
  // var passwordController = TextEditingController();
  // var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20, left: 24, top: 60),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyles.textStyle30.copyWith(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Enter your details below & free sign up',
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.gryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
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
                            'Enter Name',
                            style: TextStyles.textStyle14.copyWith(
                              color: AppColors.darkgrey,
                            ),
                          ),
                          CustomTextFormField(
                            controller: TextEditingController(),
                            hintText: 'Enter Name',
                          ),
                          Gap(25),
                          Text(
                            'Enter Email',
                            style: TextStyles.textStyle14.copyWith(
                              color: AppColors.darkgrey,
                            ),
                          ),
                          CustomTextFormField(
                            controller: TextEditingController(),
                            hintText: 'Enter Email',
                          ),
                          Gap(13),
                          Text(
                            'Enter Password',
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
                            hintText: 'Password',
                          ),
                          Gap(15),
                          // Text(
                          //   'Confirm Password',
                          //   style: TextStyles.textStyle14.copyWith(
                          //     color: AppColors.darkgrey,
                          //   ),
                          // ),
                          // PasswordTextFormField(
                          //   controller: TextEditingController(),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your password';
                          //     } else if (value.length < 6) {
                          //       return 'Password must be at least 6 characters';
                          //     }
                          //     return null;
                          //   },
                          //   hintText: 'Confirmation password',
                          // ),
                          Gap(34),
                          MainButton(
                            text: 'Create Account',
                            onPressed: () {
                              Navigation.pushNamedandRemoveUntilTo(
                                context,
                                Routes.mainScreen,
                              );
                              // isChecked
                              //     ? () {
                              //         ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(content: Text('Checked')),
                              //         );
                              //       }
                              //     : null;
                            },
                          ),
                          Gap(17),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
                                ),
                                value: isChecked,
                                onChanged: (value) {
                                  isChecked = value!;

                                  setState(() {});
                                },
                              ),

                              Text(
                                'By creating an account you have to agree\n with our them & condication.',
                                style: TextStyles.textStyle12.copyWith(
                                  color: AppColors.gryColor,
                                ),
                              ),
                            ],
                          ),
                          Gap(25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyles.textStyle15.copyWith(
                                  color: AppColors.gryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigation.pushReplacementNamed(
                                    context,
                                    Routes.loginScreen,
                                  );
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyles.textStyle15.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
