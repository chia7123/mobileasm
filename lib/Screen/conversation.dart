import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      //controller: searchtextcontol,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Enter Message here",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () async {
//print("${Constants.myName} 1");
                        //print("${ await HelperFunctions.getuserNameSharedPreference()} 123");
            
                        //initiateSearch();
                        FocusScope.of(context).unfocus();
                        //searchtextcontol.clear();
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
            ),
          ],
        ),
      ),
    );
  }
}
