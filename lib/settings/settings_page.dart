import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
    title: 'Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      home: SettingPageUI());
  }
}
class SettingPageUI extends StatefulWidget {
  @override
  _SettingPageUIState createState() => _SettingPageUIState();
}

class _SettingPageUIState extends State<SettingPageUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontSize: 22)),
        leading: IconButton(
          onPressed: (){},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text("Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            TextButton(
              child: Text('Change Password'),
              onPressed: _changePassword),
          ],
        ),
      ),
    );
  }

  
void _changePassword() async{
  String password;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
          User currentUser = firebaseAuth.currentUser;
          currentUser.updatePassword(password).then((_){
            print("Password Succesfully changed");
          }).catchError((error){
            print("An Error has occured changing password");
          });
}
}