import 'dart:io';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/list_for_account.dart';

import 'package:coursely/core/constants/app_images.dart';
import 'package:flutter_svg/svg.dart';

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
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   clipBehavior: Clip.antiAlias,
      //   scrolledUnderElevation: 0,
      //   shadowColor: Colors.transparent,
      //   backgroundColor: AppColors.backGroundColor,
      //   title: Text(
      //     "Account",
      //     style: TextStyles.textStyle24.copyWith(
      //       fontWeight: FontWeight.bold,
      //       fontFamily: "Poppins",
      //       color: AppColors.secondaryColor,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap(40),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : const AssetImage('assets/images/welcome.png')
                            as ImageProvider,

                  backgroundColor: AppColors.gryColor,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.backGroundColor,
                      child: IconButton(
                        onPressed: () async {
                          imagePicker = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (imagePicker != null) {
                            final bytes = await File(
                              imagePicker?.path ?? "",
                            ).readAsBytes();

                            setState(() {
                              image = File(imagePicker?.path ?? "");
                            });
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? "",
                    style: TextStyles.textStyle24.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                Text("UIUX designer"),

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
                          color: Colors.grey.shade500.withValues(alpha: 0.7),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListForAccount(
                          text: "Edit Profile",
                          onTap: () {},
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
                          onTap: () {},
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
  }
}
