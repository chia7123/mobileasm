import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imageUrl);

  final String imageUrl;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  CollectionReference userInfo = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  String imageUrl;

  @override
  void initState() {
    imageUrl = widget.imageUrl;

    super.initState();
  }

  Future uploadPhoto() async {
    final imageStorage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image')
        .child(FirebaseAuth.instance.currentUser.uid + '.jpg');

    await imageStorage.putFile(_pickedImage);
    final url = await imageStorage.getDownloadURL();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'imageUrl': url});
  }

  void _showdialog(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: ctx,
      builder: (ctx) {
        return Container(
          height: 120,
          child: ListView(
            children: [
              TextButton.icon(
                  onPressed: _pickImageCamera,
                  icon: Icon(Icons.camera),
                  label: Text('Camera')),
              Divider(),
              TextButton.icon(
                  onPressed: _pickImageGallery,
                  icon: Icon(Icons.album),
                  label: Text('Gallery')),
            ],
          ),
        );
      },
    );
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    uploadPhoto();
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    uploadPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : imageUrl != null
                  ? NetworkImage(imageUrl)
                  : NetworkImage(
                      'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'),
        ),
        TextButton.icon(
          onPressed: () {
            _showdialog(context);
          },
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            "Upload Image",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
