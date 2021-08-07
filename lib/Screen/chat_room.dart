import 'package:dating_app/Screen/search.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dating_app/welcomePage.dart';
class ChatRoom extends StatefulWidget {
  static const routeName= '/chatroom';

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  GoogleSignIn().disconnect();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomePage()));}
                            );
              },
              icon: Icon(Icons.logout),
              label: Text('Logout')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            // builder: (context) => search()
          ));
        },
      ),
    );
      
  }
}