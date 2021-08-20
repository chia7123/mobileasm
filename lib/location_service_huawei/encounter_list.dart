import 'package:dating_app/Screen/chat_room.dart';
import 'package:dating_app/database/database.dart';
import 'package:dating_app/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class encounter_list_page extends StatefulWidget {


  const encounter_list_page({Key key}) : super(key: key);

  @override

  _encounter_list_pageState createState() => _encounter_list_pageState();
}

class _encounter_list_pageState extends State<encounter_list_page> with WidgetsBindingObserver{
  @override
  initState() {
    get();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      get();
    });
  }

  void get()
  async {
    await DatabaseMethods().getEncounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Encounter List"),),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: encountered_username.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: (){
                setState(() {
                  encountered_username.removeAt(index);
                  DatabaseMethods().saveEncounter();
                });
              },


                child: encounter_container(encountered_username[index]));
          }
      ),
    );
  }
}

class encounter_container extends StatefulWidget {

  String name;
  encounter_container(this.name);
  @override
  _encounter_containerState createState() => _encounter_containerState();
}

class _encounter_containerState extends State<encounter_container> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFA9294F),
            borderRadius: BorderRadius.circular(8),boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 5),
          ),
        ]),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(40)),
              child: Text("${widget.name.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(widget.name, style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 18),),
            )
          ],
        ),
      ),
    );
  }
}

