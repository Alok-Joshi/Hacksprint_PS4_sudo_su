import 'package:bookmyspot/constrains.dart';
import 'package:flutter/material.dart';


class BMSFilledButton extends StatelessWidget {
  BMSFilledButton({Key? key, this.width, this.height, this.child}) : super(key: key);
  double? width;
  double? height;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 65,
      width: width ?? 343,
      decoration: BoxDecoration(
        color: Color(button_primary_color),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(child: child),
    );
  }
}


class BMSOutlinedButton extends StatelessWidget {
  BMSOutlinedButton({Key? key, this.width, this.height, this.child}) : super(key: key);
  double? width;
  double? height;
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 65,
      width: width ?? 343,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(button_primary_color), width: 5)
      ),
      child: Center(child: child),
    );
  }
}
