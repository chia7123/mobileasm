import 'package:dating_app/Screen/chat_room.dart';
import 'package:dating_app/Screen/splashScreen.dart';
import 'package:dating_app/location_service_huawei/global.dart';
import 'package:dating_app/widget/drawer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Phoenix(child: MyApp(),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: SECONDARY_COLOR,
      ),
      home: SplashScreen(),
      // home: Drawer(),
      routes: {ChatRoom.routeName: (context) => ChatRoom()},
    );
  }
}
