import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Screen/conversation.dart';
import 'package:dating_app/Screen/search.dart';
import 'package:dating_app/database/constant.dart';
import 'package:dating_app/database/database.dart';
import 'package:dating_app/database/helperfunctions.dart';
import 'package:dating_app/location_service_huawei/global.dart';
import 'package:dating_app/location_service_huawei/location_class.dart';
import 'package:dating_app/shared_function.dart';
import 'package:dating_app/widget/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_callback.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/location/location_settings_request.dart';
import 'package:huawei_location/location/location_settings_states.dart';
import 'package:huawei_location/permission/permission_handler.dart';

List<dynamic> encountered_username = [];

class ChatRoom extends StatefulWidget {
  static const routeName = '/chatroom';

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  //Start of variable for location
  PermissionHandler permissionHandler;
  FusedLocationProviderClient locationService;
  List<LocationRequest> locationRequestList;
  LocationSettingsRequest locationSettingsRequest;
  LocationRequest locationRequest;
  StreamSubscription<Location> streamSubs;
  LocationCallback locationCallback;
  int requestCode;
  String locationstr = "";

  QuerySnapshot locationsnapshot;

  //End of variable for location

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String name = snapshot.data.docs[index]
                      .data()["chatroomID"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, "");
                  return ChatRoomsTile(
                    userName: name,
                    chatRoom: snapshot.data.docs[index].data()["chatroomID"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    WidgetsBinding.instance.addObserver(this);

    //Start of init location service <Lee Kai Wei>
    checkLocationSettings();
    locationService = FusedLocationProviderClient();
    permissionHandler = PermissionHandler();
    locationRequest = LocationRequest();
    locationRequest.interval = 5000;
    locationRequestList = <LocationRequest>[locationRequest];
    locationSettingsRequest =
        LocationSettingsRequest(requests: locationRequestList);

    streamSubs = locationService.onLocationData.listen((location) {
      print(location.toString());
    });
    hasPermission();

    //End of init location service <Lee Kai Wei>

    setStatus("Offline");
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getuserNameSharedPreference();
    setState(() {
      databaseMethods.getChatRooms(Constants.myName).then((val) {
        setState(() {
          chatRoomStream = val;
        });
      });
    });
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  void hasPermission() async {
    try {
      final bool status = await permissionHandler.hasLocationPermission();
      if (status == false) {
        requestPermission();
      } else {
        maketoast("Permission Existed");
      }
    } catch (e) {
      maketoast(e.toString());
    }
  }

  void requestPermission() async {
    try {
      final bool status = await permissionHandler.requestLocationPermission();
      maketoast("Permission granted");
    } catch (e) {
      maketoast(e.toString());
    }
  }

  void checkLocationSettings() async {
    try {
      LocationSettingsStates states =
          await locationService.checkLocationSettings(locationSettingsRequest);
      maketoast(states.toString());
      dev.log(states.toString());
    } catch (e) {
      setState(() {
        maketoast(e.toString());
      });
    }
  }

  //Start of huawei location function <Lee Kai Wei>
  void requestLocationUpdates() async {
    try {
      requestCode = await locationService.requestLocationUpdatesCb(
          locationRequest, locationCallback);

      setState(() {
        dev.log("Location updates requested successfully " +
            locationCallback.toString());
      });
    } catch (e) {
      setState(() {
        dev.log(e.toString());
      });
    }
  }

  void removeLocationUpdates() async {
    try {
      await locationService.removeLocationUpdates(requestCode);
      requestCode = null;
      setState(() {
        dev.log("Location updates are removed successfully");
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  void requestBackgroundLocationPermission() async {
    try {
      bool status =
          await permissionHandler.requestBackgroundLocationPermission();
      setState(() {
        dev.log("Is permission granted $status");
      });
    } catch (e) {
      setState(() {
        dev.log(e.toString());
      });

      //End of huawei location function <Lee Kai Wei>

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR,
        drawer: Drawers(),
        appBar: AppBar(
          title: Text(
            'Chat Room',
            style: TextStyle(fontWeight: FontWeight.bold, color: PRIMARY_COLOR),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              color: PRIMARY_COLOR,
              height: 470,
              child: chatRoomList(),
            ),
            Positioned(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            List<dynamic> random_name = [];

                            await FirebaseFirestore.instance
                                .collection("users")
                                .where("status", isEqualTo: "Online")
                                .get()
                                .then((val) {
                              val.docs.forEach((result) {
                                if (result.data()['name'] != Constants.myName)
                                  random_name.add(result.data()['name']);
                              });
                            });

                            await databaseMethods.getEncounter();

                            print(encountered_username);
                            print(random_name);

                            if (random_name.isNotEmpty) {
                              var lst1 = random_name;
                              var lst2 = encountered_username;
                              var set1 = Set.from(lst1);
                              var set2 = Set.from(lst2);
                              random_name =
                                  List.from(set1.difference(set2)).toList();
                            } else {
                              maketoast("No user online");
                            }
                            if (random_name.isNotEmpty) {
                              random_name.shuffle();
                              await databaseMethods
                                  .getUserByUserName(random_name[0])
                                  .then((val) {
                                val.docs.forEach((element) {
                                  maketoast("Finding user");
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: element['name'],
                                          descriptions: element['description'],
                                          img: element['imageUrl'],
                                        );
                                      });
                                });
                              });
                            }
                          },
                          child:
                              customcontainer(Icons.search, "Find Random User"),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Location location =
                                await locationService.getLastLocation();

                            List<location_details> location_details_list = [];
                            List<Map<String, dynamic>>
                                user_location_coordinate = [];
                            List<dynamic> encountered_username = [];

                            await FirebaseFirestore.instance
                                .collection("location_data")
                                .where("name", isNotEqualTo: Constants.myName)
                                .get()
                                .then((val) {
                              val.docs.forEach((result) {
                                user_location_coordinate.add(result.data());
                              });
                            });

                            databaseMethods.getEncounter();

                            if (user_location_coordinate.isNotEmpty) {
                              for (var e in user_location_coordinate) {
                                location_details _temp = new location_details(
                                    pow(
                                        pow(e['longitude'] - location.longitude, 2) +
                                            pow(e['latitude'] - location.latitude, 2),
                                        1 / 2),
                                    e['name']);
                                location_details_list.add(_temp);
                              }
                            }

                            //sort to ascending order
                            if (location_details_list.isNotEmpty) {
                              location_details_list.sort(
                                  (a, b) => a.distance.compareTo(b.distance));

                              location_details_list.take(50);
                              location_details_list.shuffle();
                            }

                            // compare closest user to encounter history
                            if (location_details_list.isNotEmpty &&
                                encountered_username.isNotEmpty) {
                              for (int i = 0;
                                  i < location_details_list.length;
                                  i++) {
                                for (int j = 0;
                                    j < encountered_username.length;
                                    j++) {
                                  if (location_details_list[i].name ==
                                      encountered_username[j]) {
                                    location_details_list.removeAt(i);
                                  }
                                }
                              }
                            }

                            if (location_details_list.isNotEmpty) {
                              await databaseMethods
                                  .getUserByUserName(
                                      location_details_list[0].name)
                                  .then((val) {
                                val.docs.forEach((element) {
                                  maketoast("Finding user");

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: element['name'],
                                          descriptions: element['description'],
                                          img: element['imageUrl'],
                                        );
                                      });
                                });
                              });
                            }

                            await databaseMethods.saveEncounter();
                            await FirebaseFirestore.instance
                                .collection("location_data")
                                .where("name", isEqualTo: Constants.myName)
                                .get()
                                .then((val) {
                              if (val.docs.isEmpty) {
                                FirebaseFirestore.instance
                                    .collection('location_data')
                                    .add({
                                  "name": Constants.myName,
                                  "longitude": location.longitude,
                                  "latitude": location.latitude
                                });
                              } else {
                                val.docs.forEach((element) {
                                  FirebaseFirestore.instance
                                      .collection("location_data")
                                      .doc(element.id)
                                      .update({'longitude': location.longitude, 'latitude': location.latitude
                                  });

                                });

                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customcontainer(
                                Icons.near_me, "Find nearby user"),
                          ),
                        ),
                      ],
                    )))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SECONDARY_COLOR,
          child: Icon(
            Icons.search,
            color: PRIMARY_COLOR,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => search()));
          },
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoom;
  final String userName;

  ChatRoomsTile({this.userName, this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoom)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
              color: SECONDARY_COLOR,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
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
                child: Text("${userName.substring(0, 1).toUpperCase()}"),
              ),
              SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  userName,
                  style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
