import 'package:dating_app/database/constant.dart';
import 'package:dating_app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Screen/conversation.dart';
import 'Screen/search.dart';

createChatroomAndStart(BuildContext context, {String userName}) {
  print("${Constants.myName}");

  if (userName != Constants.myName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomID": chatRoomId
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)));
  } else {
    print("you cannot send message!");
  }
}

maketoast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}
