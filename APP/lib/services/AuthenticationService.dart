
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
    await pref.setString("email", user.email);
  }

  Stream<User?> authStream() async* {
    final pref = await SharedPreferences.getInstance();
    String? token = await pref.getString("token");
    String? email = await pref.getString("email");
    //
    if (token != null && email != null) {
      log(email);
      log(token);
      yield User(email, token);
    }

    // await Future.delayed(Duration(seconds: 5));
    // log("YIELDED");
    // yield User("test@email.com", "udfahsudf");
  }

  Future<User?> login(User user) async {
    try {
      var res = await http.post(Uri.https(api_host, "login"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"email": user.email, "password" : user.password}));
      log(res.body.toString());
      var bodyData = json.decode(res.body);

      var final_user = User(user.email);
      if (res.statusCode != 200) {
        final_user.error_code = res.statusCode;
        final_user.messege = bodyData["msg"];
      } else {
        final_user = User(user.email, bodyData["token"]);
        addToSharedPreferences(final_user);
      }
      return final_user;
    } catch(e) {
      log(e.toString());
    }
  }

  Future<User?> register(User user) async {
    try {
      var res = await http.post(Uri.https(api_host, "register/user"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": user.email, "password" : user.password}));
      log(res.body.toString());
      var bodyData = json.decode(res.body);
      var final_user = User(user.email);
      if (res.statusCode != 201) {
        log("Failed");
        final_user.error_code = res.statusCode;
        final_user.messege = bodyData["msg"];
      } else {
        log("Sucess");
        final_user = User(user.email, bodyData["token"]);
        addToSharedPreferences(final_user);
      }
      return final_user;
    }catch(e) {
      log(e.toString());
    }
  }

  Future logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove("token");
    await pref.remove("email");
  }

  Future<List<String>> getMyVechicles(User user) async {
    try {
      var res = await http.get(
          Uri.https(api_host, "vehicles/${user.email}"),
              headers: {
            "email" : user.email,
                "token" : user.uid!
              }
      );
      var bodyData = json.decode(res.body);
      // log(bodyData.toString());

      return (bodyData["vehicles"] as List<dynamic>).map((e) => e.toString()).toList();
    }catch(e) {
      log(e.toString());
    }

    return [];
  }


  Future addMyVechicle(String email, String car) async {
    try {
      var res = await http.post(
        Uri.https(api_host, "register/car"),
          headers: {"Content-Type": "application/json"},
        body:  jsonEncode({
          "email" : email,
          "car_rc" : car
        })
      );
    } catch(e) {
      
    }
  }

}