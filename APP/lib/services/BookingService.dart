
import 'dart:convert';
import 'dart:developer';

import 'package:bookmyspot/constrains.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class BookingService {
  Future<bool> scheduleLater(User user, String startTime, String endTime, String rc) async {
    log(startTime);

    try {
      var res = await http.post(Uri.https(api_host, "bookings"),
          headers: {
        "token" : user.uid!,
          "Content-Type": "application/json"
          },

        body: jsonEncode({
          "email" : user.email,
          "car_rc" : rc,
          "pl_id" : 1,
          "start_time" : startTime,
          "end_time" : endTime,
          "slot_name" : "B1"
        })
      );

      log(res.statusCode.toString());
      log(res.body.toString());

      if (res.statusCode != 200) {
        return false;
      }

      return true;
    }catch(e) {
      log(e.toString());
    }

    return false;
  }

  Future<bool> scheduleImmediately(User user,  String endTime, String rc) async {
    log(rc);
    try {
      var res = await http.post(Uri.https(api_host, "bookings"),
          headers: {
            "token" : user.uid!
          },

          body: jsonEncode({
            "email" : user.email,
            "car_rc" : rc,
            "end_time" : endTime,
          })
      );

      log(res.statusCode.toString());
      log(res.body.toString());

      if (res.statusCode != 200) {
        return false;
      }

      return true;
    }catch(e) {
      log(e.toString());
    }

    return false;
  }

}