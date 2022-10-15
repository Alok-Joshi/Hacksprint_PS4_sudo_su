import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/services/AuthenticationService.dart';
import 'package:flutter/material.dart';

import '../constrains.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.appUser}) : super(key: key);
  User appUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: const Color(button_primary_color),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: const Icon(Icons.account_circle, size: 50, color: Colors.white,),
                  ),
                  const SizedBox(height: 20,),
                  Text(widget.appUser.email, style: TextStyle(
                      fontSize: 20
                  ),),
                  Divider(thickness: 2,)
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await AuthenticationService().logout();
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                  Navigator.pushReplacementNamed(context, '/');
                },
                  child: BMSFilledButton(child: ButtonText(text: "Logout",), color: Colors.red, ))
            ],
          ),
        ),
      )
    );
  }
}
