import 'package:flutter/material.dart';


class User{
  String? _uid;
  String _email;
  String? _password;
  int? error_code;
  String? messege;

  User(this._email, [this._uid, this._password]);

  String? get password => _password;

  String get email => _email;

  String? get uid => _uid;
}