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