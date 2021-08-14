import 'package:dating_app/Screen/chat_room.dart';
import 'package:dating_app/authentication/auth.dart';
import 'package:dating_app/initialProfile.dart';
import 'package:dating_app/welcomePage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
      // home: InitialProfileScreen(),
      routes: {
        
        ChatRoom.routeName: (context)=> ChatRoom()
      },
    );
  }
}
