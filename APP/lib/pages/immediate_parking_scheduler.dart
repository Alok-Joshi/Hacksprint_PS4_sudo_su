import 'package:bookmyspot/components/bottomsheets.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../components/pickers.dart';
import '../components/typography.dart';
import '../constrains.dart';
import '../utils.dart';

class ImmediateReservation extends StatefulWidget {
  const ImmediateReservation({Key? key}) : super(key: key);

  @override
  State<ImmediateReservation> createState() => _ImmediateReservationState();
}

class _ImmediateReservationState extends State<ImmediateReservation> {
  bool disablePlage = false;
  final _laterFormKey = GlobalKey<FormState>();
  final _exitDateTime = TextEditingController();

  Widget laterReservationConfirmationUI(BuildContext context) {


    return Padding(padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Typography0(text: "Confirm!"),
          Typography1(text: "${getVerbalPresentation(DateTime.now())} to ${getVerbalPresentation(construct(_exitDateTime.text))}",),
          SizedBox(height: 20,),
          Typography2(text: "Note: Once a parking spot is booked the reservation can't be changed!"),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    disablePlage = true;
                  });
                  Navigator.pop(context);
                  // TODO: implement the execution
                  await Future.delayed(Duration(seconds: 2));
                  setState(() {
                    disablePlage = false;
                  });
                },
                child: BMSFilledButton(width: 170,
                  child: ButtonText( text: 'confirm',),),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BMSOutlinedButton(width: 170,
                  child: ButtonText(text: 'cancel', color: Color(button_primary_color),),),
              )
            ],
          )
        ],
      ),);
  }

  void reserveSpot() {
    showBasicBottomModalSheet(context, laterReservationConfirmationUI(context));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: 700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Form(
                  key: _laterFormKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Typography0(text: "Select the exit time..."),
                      SizedBox(height: 20,),
                      BMSDateTimePicker(label: "exit time" ,dateController: _exitDateTime,),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => reserveSpot(),
              child: BMSFilledButton(
                child: ButtonText(text: "Reserve",),
              ),
            )
          ],
        ),
      )
    );
  }
}
