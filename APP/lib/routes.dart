import 'package:bookmyspot/pages/authentication_page.dart';
import 'package:bookmyspot/pages/dashboard.dart';
import 'package:bookmyspot/pages/immediate_parking_scheduler.dart';
import 'package:bookmyspot/pages/later_parking_scheduler.dart';
import 'package:bookmyspot/pages/test_page.dart';
import 'package:bookmyspot/wrapper.dart';
import 'package:flutter/material.dart';

class BookMySpotAppRouts {
  Map<String, Widget Function(BuildContext)> routeMap = {
    "/" : (context) => const Wrapper(),
    "/test" : (context) => const TestPage(),
    "/auth" : (context) => const AuthenticationPage(),
    "/home" : (context) => const Dashboard(),
    "/reserve/immediate" : (context) => const ImmediateReservation(),
    "/reserve/later" : (context) => const LaterReservation()
  };
}
