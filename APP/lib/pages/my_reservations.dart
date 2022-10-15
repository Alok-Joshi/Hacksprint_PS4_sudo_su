import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/constrains.dart';
import 'package:bookmyspot/services/BookingService.dart';
import 'package:bookmyspot/utils.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class MyReservations extends StatefulWidget {
  MyReservations({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  bool firstLoad = false;
  bool loading = true;
  Map<String, dynamic> data = {};

  Future loadReservations() async {
    setState(() {
      loading = true;
    });

     var res = await BookingService().myReservations(widget.user);

    setState(() {
      data = res;
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (!firstLoad) {
      loadReservations();
      firstLoad = true;
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            // loadVechicleInfo();
          }, icon: Icon(Icons.refresh))
        ],
        title: const Text("My Reservations", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : data.isEmpty ?
      Center(child: Text("You don't have any reservations")) :
      Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          height: 250,
          width: 343,
          decoration: BoxDecoration(
            color: Color(button_primary_color),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data["vehicle_rc"], style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w800
                ),),
                Divider(color: Colors.white, thickness: 3,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text("${data["Parking Name"]}", style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w800
                      ),),
                    ),
                    BMSOutlinedButton(
                      width: 60,
                      color: Colors.white,
                      child: ButtonText(
                        text: "${data["slot_name"]}" ,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white, thickness: 3,),
                data["start_time"] == null ?

                Text( "Upto ${getVerbalPresentation(construct(data["end_time"]))}", style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800
                ),) : Text( "${getVerbalPresentation(construct(data["start_time"]))} \nto ${getVerbalPresentation(construct(data["end_time"]))}", style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800
                ),)


              ],
            ),
          ),
        ),
      )
      ,
    );
  }
}
