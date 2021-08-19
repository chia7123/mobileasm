import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Screen/chat_room.dart';
import 'package:dating_app/database/constant.dart';
import 'package:dating_app/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class encounter_list extends StatefulWidget {
  const encounter_list({Key key}) : super(key: key);

  @override
  _encounter_listState createState() => _encounter_listState();
}


class _encounter_listState extends State<encounter_list> {
  @override
  void initState() {



    super.initState();
  }

  void getEncounterList()
  async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: Constants.myName)
        .get()
        .then((val) {
      val.docs.forEach((element) {
        if(element.data()['history']!=null)
          {
            encountered_username =
            element.data()['history'];
          }
      });
    });
  }


  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: encountered_username.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.amber,
              child: Center(child: Text(encountered_username[index])),
            );
          }
      ),

    );
  }
}
