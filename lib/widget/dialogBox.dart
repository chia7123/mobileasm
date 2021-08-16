import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:age/age.dart';

class DialogBox {
  showProfile(
    BuildContext context,
    String userName,
    String desc,
    String gender,
    String imageUrl,
    DateTime dob,
    Function startChat,
  ) async {
    bool error = false;

    await Alert(
        context: context,
        // title: userName,
        style: AlertStyle(animationType: AnimationType.grow),
        content: Column(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: !error
                    ? NetworkImage(imageUrl)
                    : NetworkImage('https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                onBackgroundImageError: (_, __) {
                  error = true;
                },
              ),
            ),
            Text(
              userName,
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
                  gender,
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
                          fromDate: dob,
                          toDate: DateTime.now(),
                          includeToDate: false)
                      .years
                      .toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
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
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Text(
                desc,
                softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () =>Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
