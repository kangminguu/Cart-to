import 'package:capstone_project/screens/register_screen.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonColor, buttonLineColor, innnerText, textColor;
  final double buttonLineOp, textColorOp, textSize;

  RoundedButton({
    super.key,
    required this.buttonColor,
    required this.buttonLineColor,
    required this.buttonLineOp,
    required this.innnerText,
    required this.textColor,
    required this.textColorOp,
    required this.textSize,
    required this.screenNum,
  });

  List screenNum = [
    // const LoginScreen(),
    const RegisterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Color(int.parse(buttonColor)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(180)),
        ),
        side: BorderSide(
          color: Color(int.parse(buttonLineColor)).withOpacity(buttonLineOp),
          width: 0.1,
        ),
      ),
      child: Text(
        innnerText,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.bold,
          color: Color(int.parse(textColor)).withOpacity(textColorOp),
        ),
      ),
    );
  }
}
