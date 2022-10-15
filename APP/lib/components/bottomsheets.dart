import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:flutter/material.dart';

void showBasicBottomModalSheet(BuildContext context, [Widget? child]) {
  showModalBottomSheet(context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      builder: (BuildContext context) {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        )
      ),
      child: child,
    );
  });
}

void showErrorModalSheet(BuildContext context, String issue, String description) {
  showModalBottomSheet(context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          )
      ),
      builder: (BuildContext context) {
        return Container(
          height: 250,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 5),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Typography0(text: issue, color: Colors.red,),
                Typography1(text: description, color: Colors.red,),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: BMSOutlinedButton(
                    color: Colors.red,
                    child: ButtonText(
                      text: "Ok!",
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}