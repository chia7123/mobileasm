import 'package:dating_app/email_signin/auth.dart';
import 'package:dating_app/google_signin/google_signin.dart';
import 'package:dating_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignInButton(
          Buttons.Google,
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogin().whenComplete(() {
              print('login success');
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            });
          },
        ),
        SignInButtonBuilder(
          icon: Icons.email,
          text: 'Sign in With Email',
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AuthPage()));
          },
          backgroundColor: Colors.cyan,
        ),
      ],
    );
  }
}
