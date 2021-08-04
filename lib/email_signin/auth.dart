import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/email_signin/auth_form.dart';
import 'package:dating_app/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _isLoading = false;
  var _isLogin = false;

  void _submitAuthForm(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
        _isLogin = isLogin;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('login success');
        Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => Home()));
      }
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('sign up success');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'email': email,
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => Home()));
    } catch (e) {
      var message = e.toString();
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
