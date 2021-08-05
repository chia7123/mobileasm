import 'package:flutter/material.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {

  TextEditingController searchtextcontol = new TextEditingController();

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
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        const Color(0x36FFFFFF),
                        const Color(0x0FFFFFFF),
                      ]
                      ),
                      borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/images/search_white.png")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
