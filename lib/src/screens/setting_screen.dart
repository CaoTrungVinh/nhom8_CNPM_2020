import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MySettingState();
  }
}

//hàm build
class _MySettingState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cài đặt',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff2E3A59),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          minimum: EdgeInsets.only(left: 20, right: 20),
          child: new Column(
            children: [
//              Text('data')
            ],
          ),
        ),
      ),
    );
  }
}
