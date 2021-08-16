import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Screen/chat_room.dart';
import 'package:dating_app/authentication/signup_image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class InitialProfileScreen extends StatefulWidget {
  static const routeName = '/initialProfile';
  final String userName;

  InitialProfileScreen(this.userName);

  @override
  _InitialProfileScreenState createState() => _InitialProfileScreenState();
}

class _InitialProfileScreenState extends State<InitialProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  CollectionReference userInfo = FirebaseFirestore.instance.collection('users');
  File _userImageFile;
  DateTime _selectedDate;
  String selectedGender;

  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();

  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    name.value= TextEditingValue(text: widget.userName);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  _showToast(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _updateProfile() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    final imageStorage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image')
        .child(user.uid + '.jpg');

    await imageStorage.putFile(_userImageFile);
    final url = await imageStorage.getDownloadURL();

    if (url == null) {
      _showToast('Please upload a profile image');
      return;
    }

    if (selectedGender == null) {
      _showToast('Please select your gender');
      return;
    }
    if (_selectedDate == null) {
      _showToast('Please select your date of birth');
      return;
    }

    if (isValid) {
      userInfo.doc(user.uid).update({
        'name': name.text,
        'imageUrl': url,
        'description': desc.text,
        'id': user.uid,
        'dob':_selectedDate,
        'gender':selectedGender,
      }).whenComplete(() => {
            _showToast('Sign up sucessful'),
            Navigator.pushReplacementNamed(context, ChatRoom.routeName)
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22, top: 40),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile Detail',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Please fill in the following information.')),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Card(
                  elevation: 10,
                  margin:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 25),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SignUpImagePicker(_pickedImage),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              key: ValueKey('name'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your nickname';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Nickname',
                              ),
                              controller: name,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownSearch<String>(
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                items: [
                                  'Male',
                                  'Female',
                                ],
                                label: "Gender",
                                hint: "Select your gender",
                                onChanged: (value) {
                                  selectedGender = value.toString();
                                },
                                selectedItem: 'Select your gender'),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Date of Birth:',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _selectedDate == null
                                          ? 'No chosen yet'
                                          : '${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                RaisedButton(
                                  color: Colors.cyan,
                                  onPressed: _presentDatePicker,
                                  child: Text(
                                    'Pick Here',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            TextFormField(
                              key: ValueKey('desc'),
                              maxLines: 6,
                              decoration: InputDecoration(
                                hintText: 'Tell us more about yourself',
                                alignLabelWithHint: true,
                              ),
                              controller: desc,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
