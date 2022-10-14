import 'package:bookmyspot/routes.dart';
import 'package:bookmyspot/wrapper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: BookMySpotAppRouts().routeMap,
      title: 'BookMySpot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
