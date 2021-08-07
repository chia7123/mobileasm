import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/widget/database/database.dart';
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

  createChatroomAndStart(String userName){
    List<String> users = [userName, ];
    databaseMethods.createChatRoom()
  }




  Widget searchList() {
    return searchsnapshot != null ? ListView.builder(
        itemCount: searchsnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            userName: searchsnapshot.docs[index]["name"],
            userDes: searchsnapshot.docs[index]["description"],
          );
        }) : Container();
  }

  @override
  void initState() {
    initiateSearch();{
    super.initState();}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () {
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
            searchList()
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userDes;
  SearchTile({this.userName, this.userDes});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: (){

            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}
