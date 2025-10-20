
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key, 
    required this.text, 
    required this.onPressed, 
    this.width = 240,
    this.height = 50,
    this.bgColor = AppColors.primaryColor, 
    this.borderColor,
    this.textColor = AppColors.backGroundColor,
    this.fontFamily = "Poppins",
    this.fontWeight ,



  });
  
  final String text;
  final Function() onPressed;
  final double width;
  final double height;
  final Color bgColor;
  final Color? borderColor;
  final Color  textColor;
  final String fontFamily;
  final dynamic fontWeight;




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width ,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color:borderColor != null ? AppColors.secondaryColor : Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8)
          )
        ),
        onPressed: (){}, 
      child: Text(text ,style: TextStyles.textStyle16.copyWith(color: textColor,fontFamily: fontFamily,fontWeight: fontWeight))),
    );
  }
}