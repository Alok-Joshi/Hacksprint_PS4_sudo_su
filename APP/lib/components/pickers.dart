import 'dart:ffi';

import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/models/user.dart';
import 'package:bookmyspot/utils.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import '../constrains.dart';
import '../services/AuthenticationService.dart';
import 'buttons.dart';

class BMSDateTimePicker extends StatefulWidget {
  BMSDateTimePicker({Key? key, this.label, this.hint, this.width, this.dateController}) : super(key: key);
  TextEditingController? dateController;
  String? label;
  String? hint;
  double? width;

  @override
  State<BMSDateTimePicker> createState() => _BMSDateTimePickerState();
}

class _BMSDateTimePickerState extends State<BMSDateTimePicker> {
  final _verbalDate = TextEditingController(text: getVerbalPresentation(DateTime.now()));


  void dateSelectorDialoge() async {
    DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1));

    if (pickedDate != null) {
    } else {
      return;
    }

    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null) {
    } else {
      return;
    }

    DateTime finalSelection = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

    log(finalSelection.toString());

    setState(() {
      if (widget.dateController != null) {
        widget.dateController!.text = finalSelection.toString();
      }

      _verbalDate.text = getVerbalPresentation(finalSelection);
    });

  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 343,
      child: TextFormField(
        readOnly: true,
        controller: _verbalDate,
        onTap: () {
          dateSelectorDialoge();
        },
        decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(button_primary_color,),
                    width: 2
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(button_primary_color)
                )
            )
        ),
      ),
    );
  }
}


class RCSelector extends StatefulWidget {
  RCSelector({Key? key, required this.user, required this.controller}) : super(key: key);
  User user;
  TextEditingController controller;


  @override
  State<RCSelector> createState() => _RCSelectorState();
}

class _RCSelectorState extends State<RCSelector> {
  List<String> vechicle_nos = [];
  bool isLoading = true;
  bool firstLoad = false;

  Future loadVechicleInfo() async {
    setState(() {
      isLoading = true;
    });

    var res = await AuthenticationService().getMyVechicles(widget.user);

    // log(res.toString());

    setState(() {
      vechicle_nos = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(!firstLoad) {
      loadVechicleInfo();
      firstLoad = true;
    }

    return Container(
      height: 200,
      child: isLoading? CircularProgressIndicator.adaptive() : ListView.builder(
        itemCount: vechicle_nos.length,
          itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.only(
              // left: 20, right: 20,
              top: 10
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.controller.text = vechicle_nos[index];
              });
            },
            child: BMSFilledButton(
              color: vechicle_nos[index] == widget.controller.text ? Colors.red : null,
              child: ButtonText(
                text: vechicle_nos[index],
              ),
            ),
          ),
        );
      })
    );
  }
}
