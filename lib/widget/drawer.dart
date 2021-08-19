import 'package:dating_app/widget/dialogBox.dart';
import 'package:dating_app/widget/user_profile.dart';
import 'package:dating_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Drawers extends StatelessWidget {
  const Drawers({Key key}) : super(key: key);

  Widget buildListTile(String text, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile('Account', Icons.account_box, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => user_Profile()));
          }),
          buildListTile('Logout', Icons.logout, () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Wrapper()));
          }),
        ],
      ),
    );
  }
}
