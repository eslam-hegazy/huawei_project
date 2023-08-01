import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../styles/colors.dart';

class UnderLineTextButton extends StatelessWidget {
  const UnderLineTextButton({
    Key? key,
     this.onPressed,
    required this.text,
    this.textStyle,
    this.decorationColor = AppColor.pineGreen,
    this.padding,
  }) : super(key: key);

  final void Function()? onPressed;
  final String text;
  final TextStyle? textStyle;
  final Color? decorationColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: decorationColor,
        padding: padding ?? EdgeInsets.only(right: 8.dp),
        textStyle: TextStyle(
          color: AppColor.pineGreen,
          fontSize: 12.4.dp,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 2,
          decorationColor: decorationColor,
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: textStyle),
    );
  }
}
