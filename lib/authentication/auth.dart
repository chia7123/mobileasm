import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/authentication/auth_form.dart';
import 'package:dating_app/database/database.dart';
import 'package:dating_app/database/helperfunctions.dart';
import 'package:dating_app/initialProfile.dart';
import 'package:dating_app/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _isLoading = false;
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
    Future saveLoggedInPreference,
    Future saveUserNamePreference,
    Future saveEmailPreference,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        saveEmailPreference;

        _databaseMethods.getUserByUserEmail(email).then((val) {
          snapshotUserInfo = val;
          HelperFunctions.saveuserNameSharedPreference(
              snapshotUserInfo.docs[0]['name']);
        });

        authResult = await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            // ignore: missing_return
            .then((value) {
          if (value != null) {
            saveLoggedInPreference;
            Fluttertoast.showToast(msg: 'Login Success');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WelcomePage()));
          }
        });
      }
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({'email': email, 'password': password, 'name': username});
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => InitialProfileScreen(username)));
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
