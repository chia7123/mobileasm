import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Screen/chat_room.dart';
import 'package:dating_app/database/constant.dart';

class DatabaseMethods {
  getUserByUserName(String name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
  }

  getLocationByUserName(String name) async {
    return await FirebaseFirestore.instance
        .collection("location_data")
        .where("name", isEqualTo: name)
        .get();
  }

  getUserByUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId)
    .collection("chats")
    .add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId)
    .collection("chats")
    .orderBy("time", descending: false)
    .snapshots();
  }

  getChatRooms(String userName) async {
      return await FirebaseFirestore.instance.collection("ChatRoom").where("users", arrayContains: userName).snapshots();
  }

  saveEncounter() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: Constants.myName)
        .get()
        .then((val) {
      FirebaseFirestore.instance
          .collection('users')
          .where("name", isEqualTo: Constants.myName);
      val.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'history': encountered_username});
      });
    });
  }


}
