import 'package:dating_app/authentication/loginORsignup.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpg'),
            fit: BoxFit.cover),
      ),
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Spacer(),
          Text(
            'Dating App',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Welcome \nYou will meet your new friends here',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login in your account to continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginOrSignUp()));
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50)),
            icon: Icon(
              Icons.keyboard_arrow_right,
              size: 25,
            ),
            label: Text('Press Here to Continue'),
          ),
        ],
      ),
    );
  }
}
