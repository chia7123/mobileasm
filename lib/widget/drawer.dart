
import 'package:dating_app/database/database.dart';
import 'package:dating_app/location_service_huawei/encounter_list.dart';
import 'package:dating_app/widget/user_profile.dart';
import 'package:dating_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

bool dark_mode=true;

Color PRIMARY_COLOR = dark_mode? Color(0xFFEEEEEE): Color(0xFF035AA6);
Color SECONDARY_COLOR = dark_mode?  Color(0xFF035AA6):Color(0xFFEEEEEE);

class Drawers extends StatefulWidget {
  const Drawers({Key key}) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: PRIMARY_COLOR,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: SECONDARY_COLOR,
              child: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: PRIMARY_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              color: PRIMARY_COLOR,
              child: Column(
                children: [
                  buildListTile('Account', Icons.account_box, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => user_Profile()));
                  }),
                  buildListTile('Encounter List', Icons.list, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => encounter_list_page()));
                  }),
                  ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      size: 26,
                      color: SECONDARY_COLOR,
                    ),
                    title: Switch(
                      value: dark_mode,
                      onChanged: (value) {
                        setState(() {
                          Phoenix.rebirth(context);


                          SECONDARY_COLOR = dark_mode? Color(0xFFEEEEEE): Color(0xFF035AA6);
                          PRIMARY_COLOR = dark_mode?  Color(0xFF035AA6):Color(0xFFEEEEEE);

                          dark_mode = value;
                          print(dark_mode);
                        });
                      },
                      activeTrackColor: SECONDARY_COLOR,
                      activeColor: PRIMARY_COLOR,
                    ),
                  ),
                  buildListTile('Logout', Icons.logout, () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Wrapper()));
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildListTile(String text, IconData icon, Function tapHandler) {
  return ListTile(
    leading: Icon(
      icon,
      size: 26,
      color: SECONDARY_COLOR,
    ),
    title: Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: SECONDARY_COLOR
      ),
    ),
    onTap: tapHandler,
  );
}
