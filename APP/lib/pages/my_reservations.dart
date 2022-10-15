import 'package:flutter/material.dart';

import '../models/user.dart';

class MyReservations extends StatefulWidget {
  MyReservations({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            // loadVechicleInfo();
          }, icon: Icon(Icons.refresh))
        ],
        title: const Text("My Vehicles", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
    );
  }
}
