import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;
  final Function() onPressed;
  final String? fontFamily;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.isDisabled = false,
    this.height,
    this.fontSize,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          height: 48.h,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: fontSize ?? 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
