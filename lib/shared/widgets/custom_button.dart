import 'package:flutter/material.dart';
import 'package:pizza_app_ui_flutter/shared/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final FontWeight fontWeight;
  final VoidCallback onClick;

  CustomButton(this.text, this.onClick,
      {this.color = ColorConstants.darkGray,
      this.fontWeight = FontWeight.w600,
      this.textSize = 20});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: fontWeight,
            fontSize: textSize),
      ),
    );
  }
}
