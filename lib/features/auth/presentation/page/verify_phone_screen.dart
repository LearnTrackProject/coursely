import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/dialogs.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

var pinputController = TextEditingController();

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigation.pop(context);
          },
          child: Icon(Icons.close),
        ),
        title: Text(
          'Verify Phone',
          style: TextStyles.textStyle18.copyWith(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(68),
            Text(
              'Code is sent to 283 835 2999 ',
              style: TextStyles.textStyle18.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.gryColor,
              ),
            ),
            Gap(17),
            Center(
              child: Pinput(
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 58,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.backGroundColor,
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                length: 4,
                controller: TextEditingController(),
              ),
            ),
            Gap(30),
            // Padding(
            //   padding: const EdgeInsets.only(right: 40, left: 40),
            //   child: Divider(),
            // ),
            Gap(38),
            Padding(
              padding: const EdgeInsets.only(right: 60, left: 60),
              child: MainButton(
                text: 'Verify and Create Account',
                onPressed: () {
                  showLoadingDialog(context);
                  Navigation.pushNamedTo(
                    context,
                    Routes.completeRegisterScreen,
                  );
                  Navigation.pop(context);
                },
              ),
            ),
            Spacer(),
            _bottomAction(context),
          ],
        ),
      ),
    );
  }
}

Padding _bottomAction(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't Recieve Code?", style: TextStyles.textStyle15),
        TextButton(
          onPressed: () {
            Navigation.pushReplacementNamed(context, Routes.phoneLogin);
          },
          child: Text(
            "Resend",
            style: TextStyles.textStyle15.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}
