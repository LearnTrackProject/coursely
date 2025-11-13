import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ListForAccount extends StatelessWidget {
  const ListForAccount({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  final String text;
  final Function() onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyles.textStyle14.copyWith(
          color: AppColors.secondaryColor,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: SvgPicture.asset(AppImages.leftSvg),
      onTap: onTap,
      leading: icon,
      iconColor: AppColors.primaryColor,
    );
  }
}
