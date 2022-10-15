import 'package:bookmyspot/constrains.dart';
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


class TabBarText extends StatelessWidget {
  TabBarText({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
          text,
        style: TextStyle(
          fontSize: 23,
          color: Colors.white,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }
}


class Typography0 extends StatelessWidget {
  Typography0({Key? key, required this.text, this.color}) : super(key: key);
  String text;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black
      ),
    );
  }
}


class Typography1 extends StatelessWidget {
  Typography1({Key? key, required this.text, this.color}) : super(key: key);
  String text;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
        fontSize: 20,
      color: color ?? Colors.black
    ),
    );
  }
}

class Typography2 extends StatelessWidget {
  Typography2({Key? key, required this.text}) : super(key: key);
  String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Colors.red),);
  }
}
