
import 'package:dating_app/authentication/google_signin.dart';
import 'package:dating_app/widget/database/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
    Future saveLoggedInPreference,
    Future saveUserNamePreference,
    Future saveEmailPreference
  ) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var isLogin = true;
  String _userEmail = '';
  String _userPassword = '';
  String _userName ='';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        isLogin,
        context,
        HelperFunctions.saveuserLoggedInSharedPreference(isLogin),
        HelperFunctions.saveuserNameSharedPreference(_userName),
        HelperFunctions.saveuserEmailSharedPreference(_userEmail),

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.cyan,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dating App',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if(!isLogin)
                            TextFormField(
                              key: ValueKey('nickname'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'The nickname must not be empty.';
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Nickname'),
                              onSaved: (value) {
                                _userName = value;
                              },
                            ),
                            TextFormField(
                              key: ValueKey('email'),
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                              ),
                              onSaved: (value) {
                                _userEmail = value;
                              },
                            ),
                            TextFormField(
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 8) {
                                  return 'Password must be at least 8 character long.';
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              onSaved: (value) {
                                _userPassword = value;
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            if (widget.isLoading) CircularProgressIndicator(),
                            if (!widget.isLoading)
                              RaisedButton(
                                color: Colors.cyan,
                                onPressed: _trySubmit,
                                child: Text(
                                  isLogin == true ? 'Login' : 'Signup',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isLogin == true
                                    ? 'Doesn\'t have an account? '
                                    : 'Already have an account?'),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isLogin = !isLogin;
                                      });
                                    },
                                    child: Text(
                                      isLogin == true ? 'Sign Up' : 'Login',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ))
                              ],
                            ),
                            SignInButton(
                              Buttons.Google,
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                provider.googleLogin().whenComplete(() {
                                  print('login success');
                                });
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
