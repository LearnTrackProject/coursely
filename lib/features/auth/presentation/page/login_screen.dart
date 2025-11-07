import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:coursely/core/widgets/dialogs.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:coursely/core/widgets/password_text_form_field.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/features/auth/data/models/user_type_enum.dart';
import 'package:coursely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coursely/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.userType});
  final UserTypeEnum userType;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String handleUserType() {
    return widget.userType == UserTypeEnum.teacher ? 'Teacher' : 'Student';
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigation.pop(context);
          if (cubit.userKind == "student" &&
              widget.userType == UserTypeEnum.student) {
            Navigation.pushNamedandRemoveUntilTo(context, Routes.mainScreen);
          } else {
            Navigation.pushNamedandRemoveUntilTo(
              context,
              Routes.mainScreen,
            ); // screen of instructor
          }
        } else if (state is AuthErrorState) {
          Navigation.pop(context);
          showMyDialog(context, "error " ?? "", DialogIconType.error);
        } else if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else {
          Navigation.pop(context);
          showMyDialog(
            context,
            "Error please try Again" ?? "",
            DialogIconType.error,
          );
        }
      },
      child: Material(
        color: AppColors.lightGrey,
        child: SingleChildScrollView(
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 30)),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Log In As ${handleUserType()} ',
                      style: TextStyles.textStyle30.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
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
                              controller: cubit.emailController,
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
                              controller: cubit.passwordController,
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
                            MainButton(
                              onPressed: () async {
                                if (cubit.formKey.currentState!.validate()) {
                                  await cubit.login(userType: widget.userType);
                                }
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
                                    Navigation.pushNamedTo(
                                      context,
                                      Routes.registerScreen,
                                      widget.userType,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
