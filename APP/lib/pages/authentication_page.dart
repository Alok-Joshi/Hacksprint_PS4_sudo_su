import 'dart:developer';

import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/textboxes.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/constrains.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> with TickerProviderStateMixin{
  late TabController _tabController;
  bool disablePlage = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void lodingStateChange() {
    log("Called");
    log(disablePlage.toString());
    setState(() {
      disablePlage = disablePlage == true ? false: true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: TabBarText(text: "BookMySpot",),
        centerTitle: false,
        backgroundColor: Color(button_primary_color),
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            TabBarText(text: "Login",),
            TabBarText(text: "Register")
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(child: LoginPage(lodingCallBack: lodingStateChange,)),
              SingleChildScrollView(child: RegisterPage(lodingCallBack: lodingStateChange,))
            ],
          ),
          disablePlage? Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ): Container(),
          disablePlage? Center(
            child: CircularProgressIndicator(),
          ): Container(),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.lodingCallBack}) : super(key: key);
  final Function lodingCallBack;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey  = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future executeLogin() async {
    widget.lodingCallBack();
    await Future.delayed(Duration(seconds: 3));
    widget.lodingCallBack();
    Navigator.pushReplacementNamed(context, '/home');
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Container(
        height: 500,
        child: Column(
          children: [
            Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  BMSTextField(label: 'email', controller: _emailController,),
                  const SizedBox(height: 10,),
                  BMSPasswordField(label: 'password', controller: _passwordController,)
                ],
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: () async {
                await executeLogin();
              },
              child: BMSFilledButton(
                child: ButtonText(
                  text: "Login",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, required this.lodingCallBack}) : super(key: key);
  final Function lodingCallBack;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFromKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future executeRegister() async {
    widget.lodingCallBack();
    await Future.delayed(Duration(seconds: 3));
    widget.lodingCallBack();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Container(
        height: 500,
        child: Column(
          children: [
            Form(
              key:  _registerFromKey,
              child: Column(
                children: [
                  BMSTextField(label: 'name', controller: _nameController,),
                  SizedBox(height: 10,),
                  BMSTextField(label: 'email', controller: _emailController,),
                  SizedBox(height: 10,),
                  BMSPasswordField(label: 'password', controller: _passwordController,),
                  SizedBox(height: 10,),
                  BMSPasswordField(label: 'confirm password', controller: _confirmPasswordController,),
                ],
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () async {
                await executeRegister();
              },
              child: BMSFilledButton(
                child: ButtonText(
                  text: "Register",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

