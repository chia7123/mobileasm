import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Passwrod'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Email: ', border: OutlineInputBorder()),
              controller: email,
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text('Reset Password'),
              onPressed: () {
                resetPassword();
              },
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() async{
    if (email.text.length == 0 || !email.text.contains('@')) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return;
    }

    await auth.sendPasswordResetEmail(email: email.text);
    Fluttertoast.showToast(msg: 'Email link has been sent to your mail');
    Navigator.pop(context);
  }
}
