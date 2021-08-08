
import 'package:dating_app/Screen/conversation.dart';
import 'package:dating_app/Screen/search.dart';
import 'package:dating_app/widget/database/constant.dart';
import 'package:dating_app/widget/database/database.dart';
import 'package:dating_app/widget/database/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dating_app/welcomePage.dart';
class ChatRoom extends StatefulWidget {
static const routeName= '/chatroom';

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return ChatRoomsTile(
              snapshot.data.docs[index].data()["chatroomID"]
              .toString().replaceAll("_", "")
              .replaceAll(Constants.myName, ""),
              snapshot.data.docs[index].data()["chatroomID"]
            );
          }
        ) : Container();
      },
    );
  }

  @override
  void initState(){
    getUserInfo();
    
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getuserNameSharedPreference();
    setState(() {
      databaseMethods.getChatRooms(Constants.myName).then((val){

      setState(() {
              chatRoomStream = val;
      });
    });
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WelcomePage()));
              },
              icon: Icon(Icons.logout))
        ],),
      body:               
                    chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => search()
          ));
        },
      ),
    );
      
  }
}

class ChatRoomsTile extends StatelessWidget {

  final String chatRoom;
  final String userName;
  ChatRoomsTile(this.userName, this.chatRoom);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoom)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40)
            ),
            child: Text("${userName.substring(0,1).toUpperCase()}"),),
          SizedBox(width: 8,),
          Text(userName)
        ],),
        
      ),
    );
  }
}