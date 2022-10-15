import 'package:bookmyspot/constrains.dart';
import 'package:flutter/material.dart';


class BMSFilledButton extends StatelessWidget {
  BMSFilledButton({Key? key, this.width, this.height, this.child, this.color}) : super(key: key);
  double? width;
  double? height;
  Widget? child;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 65,
      width: width ?? 343,
      decoration: BoxDecoration(
        color: color ?? Color(button_primary_color),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(child: child),
    );
  }
}


class BMSOutlinedButton extends StatelessWidget {
  BMSOutlinedButton({Key? key, this.width, this.height, this.child, this.color}) : super(key: key);
  double? width;
  double? height;
  Widget? child;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 65,
      width: width ?? 343,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color ?? Color(button_primary_color), width: 5)
      ),
      child: Center(child: child),
    );
  }
}

class DrawerOptions extends StatelessWidget {
  DrawerOptions({Key? key, required this.name, this.icon, this.height, this.width}) : super(key: key);
  double? height;
  double? width;
  String name;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 45,
      width: width ?? 343,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: Color(0xffC7C7C7)
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon((icon == null)? Icons.call_to_action_rounded : icon),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Center(child: Text(
                name, style:  TextStyle(
                fontSize: 20
              ),
              )),
            ),
          ],
        ),
      ),
    );;
  }
}

