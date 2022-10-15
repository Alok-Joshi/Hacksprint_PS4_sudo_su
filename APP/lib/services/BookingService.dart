
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
            "token" : user.uid!,
            "Content-Type": "application/json"
          },

          body: jsonEncode({
            "email" : user.email,
            "car_rc" : rc,
            "pl_id" : 1,
            "slot_name" : "B1",
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

  Future<Map<String, dynamic>> myReservations(User user) async {
    try {
      var res = await http.get(Uri.https(api_host, "bookings/${user.email}"),
      headers:  {
        "token" : user.uid!
      });

      log(res.body);

      return json.decode(res.body);
    }catch(e) {
      
    }
    
    return {};
  }
}