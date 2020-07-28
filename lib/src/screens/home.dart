import 'dart:io';

import 'package:appchat/src/screens/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'setting.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: Text(
          'PoroPoro',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
//            new ListTile( title: new Text("Cài đặt",),),
          new IconButton(
            icon: new Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Center(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                child: Text(
                  'Nói chuyện',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'Thoát',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }
}
