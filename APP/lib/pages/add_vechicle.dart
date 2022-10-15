import 'package:bookmyspot/components/textboxes.dart';
import 'package:bookmyspot/services/AuthenticationService.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../components/typography.dart';
import '../models/user.dart';

class AddVechiclePage extends StatefulWidget {
  AddVechiclePage({Key? key,required this.user}) : super(key: key);
  User user;

  @override
  State<AddVechiclePage> createState() => _AddVechiclePageState();
}

class _AddVechiclePageState extends State<AddVechiclePage> {
  final _rcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vehicles", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SizedBox(
        height: 700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Form(
                  child: Column(
                    children: [
                      Typography0(text: "Enter vehicle number"),
                      SizedBox(height: 20,),
                      BMSTextField(controller: _rcController,),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                AuthenticationService().addMyVechicle(widget.user.email, _rcController.text);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your car RC will be added")));
              },
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
