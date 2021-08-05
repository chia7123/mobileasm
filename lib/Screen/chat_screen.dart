import 'package:dating_app/welcomePage.dart';
import 'package:dating_app/widget/chat/message.dart';
import 'package:dating_app/widget/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 400,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Messages(),
                ),
                NewMessage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
