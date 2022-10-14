
import 'dart:convert';
import 'dart:developer';
import 'package:bookmyspot/constrains.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {


  Future addToSharedPreferences(User user) async {
    final pref = await SharedPreferences.getInstance();

    await pref.setString("token", user.uid!);
    await pref.setString("email", user.email!);
  }

  Stream<User?> authStream() async* {
    final pref = await SharedPreferences.getInstance();
    String? token = await pref.getString("token");
    String? email = await pref.getString("email");

    if (token != null && email != null) {
      yield User(email, token);
    }
  }

  Future<User?> register(User user) async {
    try {
      var res = await http.post(Uri(host: api_host, path: "/login"), body: json.encode({"email": user.email, "password" : user.password}));
      var bodyData = json.decode(res.body);
      var final_user = User(user.email);
      if (res.statusCode != 200) {
        final_user.error_code = res.statusCode;
        final_user.messege = bodyData["msg"];
      } else {
        final_user = User(user.email, bodyData["token"]);
      }
      return final_user;
    } catch(e) {
      log(e.toString());
    }
  }

  Future<User?> login(User user) async {
    try {
      var res = await http.post(Uri(host: api_host, path: "/register/user"), body: json.encode({"email": user.email, "password" : user.password}));
      var bodyData = json.decode(res.body);
      var final_user = User(user.email);
      if (res.statusCode != 200) {
        final_user.error_code = res.statusCode;
        final_user.messege = bodyData["msg"];
      } else {
        final_user = User(user.email, bodyData["token"]);
      }
      return final_user;
    }catch(e) {
      log(e.toString());
    }
  }
}