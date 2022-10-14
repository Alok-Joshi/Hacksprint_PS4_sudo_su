import 'package:bookmyspot/utils.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import '../constrains.dart';

class BMSDateTimePicker extends StatefulWidget {
  BMSDateTimePicker({Key? key, this.label, this.hint, this.dateController}) : super(key: key);
  TextEditingController? dateController;
  String? label;
  String? hint;

  @override
  State<BMSDateTimePicker> createState() => _BMSDateTimePickerState();
}

class _BMSDateTimePickerState extends State<BMSDateTimePicker> {
  final _verbalDate = TextEditingController();

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
      width: 343,
      child: TextFormField(
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
