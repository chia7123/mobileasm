import 'package:dating_app/Screen/chat_room.dart';

import 'package:dating_app/authentication/loginORsignup.dart';
import 'package:dating_app/authentication/welcomePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return ChatRoom();
            } else
              return Welcome();
          }),
    );
  }
}
