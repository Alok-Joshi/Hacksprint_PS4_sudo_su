import 'package:flutter/material.dart';


class User{
  String? _uid;
  String _email;
  String? _password;
  int? error_code = -1;
  String? messege;

  User(this._email, [this._uid, this._password]);

  String? get password => _password;

  String get email => _email;

  String? get uid => _uid;

  @override
  String toString() {
    return 'User{_uid: $_uid, _email: $_email, _password: $_password, error_code: $error_code, messege: $messege}';
  }
}