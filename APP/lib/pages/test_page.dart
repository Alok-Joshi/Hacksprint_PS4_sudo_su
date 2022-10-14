import 'package:bookmyspot/components/bottomsheets.dart';
import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/pickers.dart';
import 'package:bookmyspot/components/textboxes.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:flutter/material.dart';

import '../constrains.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String textFromTextBox = "NONE";
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Container(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BMSTextField( label: 'email', hint: 'test@email.com', obscureText: true, controller: _emailController,),
          SizedBox(height: 20,),
          BMSPasswordField(label: 'password', ),
          SizedBox(height: 20,),
          BMSDateTimePicker(label: 'From',),
          SizedBox(height: 20,),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  textFromTextBox = _emailController.text;
                });

                showBasicBottomModalSheet(context, Center(child: ButtonText(text: textFromTextBox, color: Color(button_primary_color),),));
              },
              child: BMSFilledButton(
                child: ButtonText(
                  text: "Yes",
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
