import 'package:dating_app/authentication/login.dart';
import 'package:dating_app/authentication/signup.dart';
import 'package:flutter/material.dart';
class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({ Key key }) : super(key: key);

  @override
  _LoginOrSignUpState createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool isToggle = false;
  void toggleScreen(){
    setState(() {
      isToggle= !isToggle;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isToggle){
      return SignUp(toggleScreen:toggleScreen);
    }
    else{
      return Login(toggleScreen:toggleScreen);
    }
  }
}