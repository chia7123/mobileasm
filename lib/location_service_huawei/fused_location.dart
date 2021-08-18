import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_callback.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/location/location_settings_request.dart';
import 'package:huawei_location/location/location_settings_states.dart';
import 'package:huawei_location/permission/permission_handler.dart';



class FusedLocation extends StatefulWidget {
  static const String routeName = "FusedLocationScreen";
  @override
  _FusedLocationState createState() => _FusedLocationState();
}

class _FusedLocationState extends State<FusedLocation> {

  PermissionHandler permissionHandler;
  FusedLocationProviderClient locationService;
  List<LocationRequest> locationRequestList;
  LocationSettingsRequest locationSettingsRequest;
  LocationRequest locationRequest;
  StreamSubscription<Location> streamSubs;
  LocationCallback locationCallback;




  String infoText = "Unknown";

  int requestCode;
  @override
  void initState() {
    super.initState();
    // init services
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




  }

  void requestLocationUpdates() async {
    try {
      requestCode = await locationService.requestLocationUpdatesCb(
          locationRequest, locationCallback);

      setState(() {
        infoText =
            "Location updates requested successfully " + locationCallback.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void removeLocationUpdates() async {
    try{
      await locationService.removeLocationUpdates(requestCode);
      requestCode = null;
      setState(() {
        infoText = "Location updates are removed successfully";


      });
    } catch(e){
      infoText = e.toString();
    }

  }

  Future<Location> getLastLocation() async {
    setState(() {
      infoText = "";
    });
    try {
      Location location = await locationService.getLastLocation();
      return location;
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  hasPermission() async {
    try {
      bool status = await permissionHandler.hasLocationPermission();
      setState(() {
        infoText = "Has permission: $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void requestPermission() async {
    try {
      bool status = await permissionHandler.requestLocationPermission();
      setState(() {
        infoText = "Is permission granted $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void requestBackgroundLocationPermission() async {
    try {
      bool status = await permissionHandler.requestBackgroundLocationPermission();
      setState(() {
        infoText = "Is permission granted $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void checkLocationSettings() async {
    try {
      LocationSettingsStates states = await locationService.checkLocationSettings(locationSettingsRequest);
      setState(() {
        infoText = states.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Fused Location Service'),
      ),
      body:  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                height: 140,
                child: AutoSizeText(infoText,style: TextStyle(fontSize: 30),maxLines: 9),
              ),
              Divider(
                thickness: 0.1,
                color: Colors.black,
              ),
              RaisedButton(
                child:Text("IsPermissions"),
                onPressed: hasPermission,
              ),
              RaisedButton(
                child:Text("RequestPermissions"),
                onPressed: requestPermission,
              ),
              RaisedButton(
                child:Text("RequestBackPermissions"),
                onPressed: requestBackgroundLocationPermission,
              ),
              RaisedButton(
                child:Text("checkLocationSettings"),
                onPressed: checkLocationSettings,
              ),
              RaisedButton(
                child:Text("getLastLocation"),
                onPressed: getLastLocation,
              ),
              RaisedButton(
                child:Text("requestLocationUpdates"),
                onPressed: requestLocationUpdates,
              ),
              RaisedButton(
                child:Text("removeLocationUpdates"),
                onPressed: removeLocationUpdates,
              ),

            ],
          ),
        ),
      ),
    );
  }


}