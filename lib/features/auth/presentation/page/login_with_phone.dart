import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String phoneNumber = "+63 ";
  final GlobalKey<FormState> formKey = GlobalKey();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigation.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Continue with Phone',
          style: TextStyles.textStyle18.copyWith(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColors.lightGrey,
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(32),
            Container(
              decoration: BoxDecoration(color: AppColors.lightGrey),
              width: double.infinity,
              height: 130,
              child: Container(child: Image.asset(AppImages.image4)),
            ),
            Gap(40),
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
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            "Enter Your Phone Number",
                            style: TextStyles.textStyle14.copyWith(
                              color: AppColors.gryColor,
                            ),
                          ),
                          Gap(23),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: IntlPhoneField(
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppColors.borderColor,
                                      ),
                                    ),
                                  ),
                                  languageCode: "en",
                                  onChanged: (phone) {
                                    print(phone.completeNumber);
                                  },
                                  onCountryChanged: (country) {
                                    print(
                                      'Country changed to: ${country.name}',
                                    );
                                  },
                                ),
                              ),
                              Gap(10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: MainButton(
                                    text: 'Continue',
                                    onPressed: () {
                                      Navigation.pushNamedTo(
                                        context,
                                        Routes.verifyPhoneScreen,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          _bottomAction(context),
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
      // bottomNavigationBar: _bottomAction(context),
    );
  }

  Padding _bottomAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("To Continue with phone", style: TextStyles.textStyle15),
          TextButton(
            onPressed: () {
              // Navigation.pushReplacementNamed(context, Routes.verifyPhone);
            },
            child: Text(
              "Verify",
              style: TextStyles.textStyle15.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
