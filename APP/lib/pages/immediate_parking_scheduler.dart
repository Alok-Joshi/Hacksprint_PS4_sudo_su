import 'package:bookmyspot/components/bottomsheets.dart';
import 'package:bookmyspot/services/BookingService.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../components/pickers.dart';
import '../components/typography.dart';
import '../constrains.dart';
import '../models/user.dart';
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
  final _rcController = TextEditingController();
  late User user;


  Widget laterReservationConfirmationUI(BuildContext context) {


    return Padding(padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Typography0(text: "Confirm!"),
          Typography1(text: "${getVerbalPresentation(DateTime.now())} to ${getVerbalPresentation(construct(_exitDateTime.text))}\nFor ${_rcController.text}",),
          const SizedBox(height: 20,),
          Typography2(text: "Note: Once a parking spot is booked the reservation can't be changed!"),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    disablePlage = true;
                  });
                  Navigator.pop(context);
                  var res = await BookingService().scheduleImmediately(user, _exitDateTime.text, _rcController.text);
                  setState(() {
                    disablePlage = false;
                  });

                  if (res) {
                    await showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                            )
                        ),
                        builder: (ctx) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Successful!", style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                  ),),

                                  SizedBox(height: 20,),

                                  // GestureDetector(
                                  //   onTap: () {
                                  //
                                  //   },
                                  //   child: BMSOutlinedButton(
                                  //     height: 40,
                                  //     color: Colors.white,
                                  //     child: ButtonText(
                                  //       text: "Close",
                                  //     ),
                                  //   ),
                                  // )

                                ],
                              ),
                            ),
                          );


                        });

                    Navigator.pop(context);
                  }
                  else {
                    await showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                            )
                        ),
                        builder: (ctx) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Failed!", style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                  ),),

                                  SizedBox(height: 20,),

                                  // GestureDetector(
                                  //   onTap: () {
                                  //
                                  //   },
                                  //   child: BMSOutlinedButton(
                                  //     height: 40,
                                  //     color: Colors.white,
                                  //     child: ButtonText(
                                  //       text: "Close",
                                  //     ),
                                  //   ),
                                  // )

                                ],
                              ),
                            ),
                          );


                        });
                  }
                },
                child: BMSFilledButton(width: 170,
                  child: ButtonText( text: 'confirm',),),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BMSOutlinedButton(width: 170,
                  child: ButtonText(text: 'cancel', color: const Color(button_primary_color),),),
              )
            ],
          )
        ],
      ),);
  }

  void reserveSpot() {
    if (_rcController.text == "" || _rcController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select vehicle")));
      return;
    }

    showBasicBottomModalSheet(context, laterReservationConfirmationUI(context));
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as User;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Container(
            height: 700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Form(
                      key: _laterFormKey,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Typography0(text: "Select the exit time & vehicle..."),
                          const SizedBox(height: 20,),
                          BMSDateTimePicker(label: "exit time" ,dateController: _exitDateTime,),
                          RCSelector(user: user, controller: _rcController),
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
        ),
        disablePlage? const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ): Container(),
        disablePlage? const Center(
          child: CircularProgressIndicator(),
        ): Container(),
      ],
    );
  }
}
