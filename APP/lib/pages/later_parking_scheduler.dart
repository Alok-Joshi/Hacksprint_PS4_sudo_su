import 'package:bookmyspot/components/bottomsheets.dart';
import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/pickers.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/constrains.dart';
import 'package:bookmyspot/utils.dart';
import 'package:flutter/material.dart';

class LaterReservation extends StatefulWidget {
  const LaterReservation({Key? key}) : super(key: key);

  @override
  State<LaterReservation> createState() => _LaterReservationState();
}

class _LaterReservationState extends State<LaterReservation> {
  bool disablePlage = false;

  final _laterFormKey = GlobalKey<FormState>();
  final _entryTime = TextEditingController();
  final _exitDateTime = TextEditingController();

  Widget laterReservationConfirmationUI(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Typography0(text: "Confirm!"),
        Typography1(text: "${getVerbalPresentation(construct(_entryTime.text))} to ${getVerbalPresentation(construct(_exitDateTime.text))}",),
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
  
  
  void reserveMySpot() {
    showBasicBottomModalSheet(context, laterReservationConfirmationUI(context));
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                          Typography0(text: "Select the entry & exit time..."),
                          SizedBox(height: 20,),
                          BMSDateTimePicker(label: "entry time" ,dateController: _entryTime,),
                          SizedBox(height: 20,),
                          BMSDateTimePicker(label: "exit time" ,dateController: _exitDateTime,),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => reserveMySpot(),
                  child: BMSFilledButton(
                    child: ButtonText(text: "Reserve",),
                  ),
                )
              ],
            ),
          )
        ),
        disablePlage? Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ): Container(),
        disablePlage? Center(
          child: CircularProgressIndicator(),
        ): Container(),
      ],
    );
  }
}
