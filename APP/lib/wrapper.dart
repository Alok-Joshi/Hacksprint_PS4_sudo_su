import 'package:bookmyspot/pages/authentication_page.dart';
import 'package:bookmyspot/pages/test_page.dart';
import 'package:flutter/material.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return const AuthenticationPage();
  }
}
