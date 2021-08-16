import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/widget/database/database.dart';



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
              onPressed: _changePassword,
              child: Text('Change Password'),),
            TextButton(
              onPressed: _updateEmail, 
              child: Text('Update Email'),)

          ],
        ),
      ),
    );
  }

  
void _changePassword() {
  @override
        
  UserCredential authResult;
  var password;
  FirebaseFirestore.instance
    .collection('users')
    .doc(authResult.user.uid)
    .set({'password': password});
}

void _updateEmail() {

  @override

  UserCredential authResult;
  var email;
  FirebaseFirestore.instance
    .collection('users')
    .doc(authResult.user.uid)
    .set({'email': email});
}

}