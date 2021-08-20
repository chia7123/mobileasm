
import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/picker/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class user_Profile extends StatefulWidget {
  const user_Profile({Key key}) : super(key: key);

  @override
  _user_ProfileState createState() => _user_ProfileState();
}

class _user_ProfileState extends State<user_Profile> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data();
        desc.value = TextEditingValue(text: data['description']);
      }
    });

    super.initState();
  }

  TextEditingController desc = TextEditingController();

  Future<void> updateProfile(String imageUrl) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
          'description': desc.text,
        })
        .whenComplete(() => Fluttertoast.showToast(
            msg: 'Update Successful',
            backgroundColor: Colors.white,
            textColor: Colors.black))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    bool error = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final doc = snapshot.data;
                return Card(
                  elevation: 20,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          UserImagePicker(doc['imageUrl']),
                          Text(
                            doc['name'],
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gender : ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                doc['gender'],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Age : ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                Age.dateDifference(
                                        fromDate: doc['dob'].toDate(),
                                        toDate: DateTime.now(),
                                        includeToDate: false)
                                    .years
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Description : ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.grey[400],
                            child: TextField(
                              controller: desc,
                              minLines: 4,
                              maxLines: null,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            color: Theme.of(context).primaryColor,
                            child: Text('Save'),
                            onPressed: () {
                              updateProfile(doc['imageUrl']);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
