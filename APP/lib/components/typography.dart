import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  ButtonText({Key? key,required this.text, this.color}) : super(key: key);
  String text;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700
      ),
    );
  }
}
