import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared_function.dart';

class deco_var {
  deco_var._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, img;

  const CustomDialogBox({Key key, this.title, this.descriptions, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(deco_var.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: deco_var.padding,
              top: deco_var.avatarRadius + deco_var.padding,
              right: deco_var.padding,
              bottom: deco_var.padding),
          margin: EdgeInsets.only(top: deco_var.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(deco_var.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      createChatroomAndStart(context, userName: widget.title);
                    },
                    child: Text(
                      "Block",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        createChatroomAndStart(context, userName: widget.title);
                      },
                      child: Text(
                        "Chat",
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: deco_var.padding,
          right: deco_var.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: deco_var.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(deco_var.avatarRadius)),
                child: Image.network(widget.img)),
          ),
        ),
      ],
    );
  }
}
