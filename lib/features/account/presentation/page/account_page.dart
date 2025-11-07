import 'dart:io';

 import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
 import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/list_for_account.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(10),
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

              Gap(20),
              ListForAccount(text: "Favourite", onTap: () {}),
              Gap(10),
              ListForAccount(text: "Edit Account", onTap: () {}),
              Gap(10),
              ListForAccount(text: "Settings and Privacy", onTap: () {}),
              Gap(10),
              ListForAccount(text: "Help", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
