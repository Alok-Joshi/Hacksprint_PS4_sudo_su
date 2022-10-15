import 'dart:developer';

import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/constrains.dart';
import 'package:bookmyspot/services/AuthenticationService.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'add_vechicle.dart';

class MyVechicles extends StatefulWidget {
  MyVechicles({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  State<MyVechicles> createState() => _MyVechiclesState();
}

class _MyVechiclesState extends State<MyVechicles> {
  bool firstLoad = false;
  bool loading = false;
  List<String> vechicle_nos = [];

  Future loadVechicleInfo() async {
    setState(() {
      loading = true;
    });

    var res = await AuthenticationService().getMyVechicles(widget.user);

    // log(res.toString());

    setState(() {
      vechicle_nos = res;
      loading = false;
    });
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!firstLoad) {
      setState(() {
        loadVechicleInfo();
        firstLoad = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            loadVechicleInfo();
          }, icon: Icon(Icons.refresh))
        ],
        title: const Text("My Vehicles", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: vechicle_nos.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20,
                  top: 10
              ),
              child: BMSFilledButton(
                child: ButtonText(
                  text: vechicle_nos[index],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(button_primary_color),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddVechiclePage(user: widget.user,)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
