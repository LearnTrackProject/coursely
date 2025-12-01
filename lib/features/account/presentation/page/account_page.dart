import 'dart:io';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/account_cubit.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/list_for_account.dart';

import 'package:coursely/core/constants/app_images.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  XFile? imagePicker;
  File? image;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Account",
              style: TextStyles.textStyle24.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(40),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          state.student?.imageUrl != null &&
                              state.student!.imageUrl!.isNotEmpty
                          ? NetworkImage(state.student!.imageUrl!)
                          : const AssetImage('assets/images/welcome.png')
                                as ImageProvider,
                      backgroundColor: AppColors.gryColor,
                    ),
                    Center(
                      child: Text(
                        state.student?.name ??
                            FirebaseAuth.instance.currentUser?.displayName ??
                            "User",
                        style: TextStyles.textStyle24.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.student?.profession ?? "Student",
                      style: TextStyles.textStyle14.copyWith(
                        color: AppColors.gryColor,
                        fontFamily: "Poppins",
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.backGroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500.withValues(
                                alpha: 0.7,
                              ),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListForAccount(
                              text: "Edit Profile",
                              onTap: () {
                                context.push(Routes.editProfileScreen);
                              },
                              icon: Icon(Icons.person),
                            ),
                            ListForAccount(
                              text: "Payment Option",
                              onTap: () {},
                              icon: Icon(Icons.payment),
                            ),
                            ListForAccount(
                              text: "Terms & Conditions",
                              onTap: () {},
                              icon: Icon(Icons.article),
                            ),
                            ListForAccount(
                              text: "My Certificates",
                              onTap: () {},
                              icon: Icon(Icons.workspace_premium),
                            ),
                            ListForAccount(
                              text: "Help Center",
                              onTap: () {},
                              icon: Icon(Icons.headset_mic),
                            ),
                            ListForAccount(
                              text: "Invite Friends",
                              onTap: () {},
                              icon: Icon(Icons.near_me),
                            ),
                            ListForAccount(
                              text: "Logout",
                              onTap: () async {
                                // sign out and clear local prefs
                                try {
                                  await FirebaseAuth.instance.signOut();
                                } catch (_) {}
                                try {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('is_logged_in');
                                  await prefs.remove('user_kind');
                                } catch (_) {}
                                Navigation.pushNamedandRemoveUntilTo(
                                  context,
                                  Routes.welcome,
                                );
                              },
                              icon: Icon(Icons.subdirectory_arrow_left),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
