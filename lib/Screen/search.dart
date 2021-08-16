import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Screen/conversation.dart';
import 'package:dating_app/widget/database/constant.dart';
import 'package:dating_app/widget/database/database.dart';
import 'package:dating_app/widget/database/helperfunctions.dart';
import 'package:dating_app/widget/dialogBox.dart';
import 'package:flutter/material.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController searchtextcontol = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchsnapshot;

  initiateSearch() {
    databaseMethods.getUserByUserName(searchtextcontol.text).then((val) {
      setState(() {
        searchsnapshot = val;
      });
    });
  }

  Widget searchList(BuildContext context) {
    return searchsnapshot != null
        ? ListView.builder(
            itemCount: searchsnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                context: context,
                userName: searchsnapshot.docs[index]["name"],
                userDes: searchsnapshot.docs[index]["description"],
                gender: searchsnapshot.docs[index]["gender"],
                imageUrl: searchsnapshot.docs[index]["imageUrl"],
                dob: searchsnapshot.docs[index]["dob"].toDate(),
              );
            })
        : Container();
  }

  createChatroomAndStart({String userName}) {
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

  Widget SearchTile({
    BuildContext context,
    String userName,
    String userDes,
    String gender,
    String imageUrl,
    DateTime dob,
  }) {
    return GestureDetector(
      onTap: () async => await DialogBox().showProfile(
        context,
        userName,
        userDes,
        gender,
        imageUrl,
        dob,
        createChatroomAndStart(userName: userName),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                Text(
                  userDes,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatroomAndStart(userName: userName);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  "Message",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();
    {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.black45,
          child: Column(
            children: [
              Container(
                color: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchtextcontol,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search Username...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () async {
                        print("${Constants.myName} 1");
                        print(
                            "${await HelperFunctions.getuserNameSharedPreference()} 123");

                        initiateSearch();
                        FocusScope.of(context).unfocus();
                        searchtextcontol.clear();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/images/search_white.png")),
                    ),
                  ],
                ),
              ),
              searchList(context)
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
