import 'package:bookmyspot/pages/test_page.dart';
import 'package:bookmyspot/wrapper.dart';
import 'package:flutter/material.dart';

class BookMySpotAppRouts {
  Map<String, Widget Function(BuildContext)> routeMap = {
    "/" : (context) => const Wrapper(),
    "/test" : (context) => const TestPage()
  };
}
