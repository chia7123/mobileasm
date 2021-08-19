import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/authentication/resetPassword.dart';
import 'package:dating_app/database/database.dart';
import 'package:dating_app/database/helperfunctions.dart';
import 'package:dating_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  final Function toggleScreen;
  const Login({Key key, this.toggleScreen}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FToast fToast;
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _showToast(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future login(String email, String password) async {
    try {
      UserCredential authResult;

      HelperFunctions.saveuserEmailSharedPreference(email);
      _databaseMethods.getUserByUserEmail(email).then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveuserNameSharedPreference(
            snapshotUserInfo.docs[0]['name']);
      });

      authResult = await firebaseAuth
          .signInWithEmailAndPassword(
              // ignore: missing_return
              email: email,
              password: password)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveuserLoggedInSharedPreference(true);
          Fluttertoast.showToast(msg: 'Login Success');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Wrapper()));
        }
      });

      setLoading(false);
    } on SocketException {
      setLoading(false);
      setMessage('No internet, Please connect to internet');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      setLoading(false);
      setMessage(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void setLoading(val) {
    _isLoading = val;
  }

  void setMessage(message) {
    _errorMessage = message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter a email address';
                    } else {
                      if (!val.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  controller: _emailController,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (val) =>
                      val.length < 8 ? 'Enter more then 8 character' : null,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResetPassword(),
                      ),
                    );
                  },
                  child: Text('Forgot Password ?'),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await login(_emailController.text.trim(),
                          _passwordController.text.trim());
                    }
                  },
                  height: 50,
                  minWidth: isLoading ? null : double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text('Don\'t have an account ?'),
                    SizedBox(
                      width: 2,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggleScreen();
                      },
                      child: Text('Sign up'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
