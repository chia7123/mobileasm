
import 'package:dating_app/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut().whenComplete(() =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomePage())));
            },
            icon: Icon(Icons.logout),
            label: Text('Logout')),
      ),
    );
  }
}
