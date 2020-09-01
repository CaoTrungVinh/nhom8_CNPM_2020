import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/authenrication_provider.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'setting_screen.dart';

//class HomeScreen extends StatelessWidget {
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PoroPoro',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ), //style of title
        ), //title
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                ), //gọi tới màn hình cài đặt - 1. chọn giao diện setting
              );
            }, //action cho button
          )
        ], //actions
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //nếu đã đăng nhập thì hiển thị tên tài khoản
                context.watch<AuthenticationProvider>().isSignedIn
                    ? FlatButton(
                        onPressed: () {},
                        child: Text(
                          context
                                  .watch<AuthenticationProvider>()
                                  .currentUser
                                  .displayName ??
                              '',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : FlatButton(
                        // nếu chưa đăng nhập hiển thị đăng nhập
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                if (context.watch<AuthenticationProvider>().isSignedIn)
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(),
                        ),
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
                FlatButton(
                  onPressed: () {
                    _showDialogExit(context);
                  },
                  child: Text(
                    'Thoát',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _showDialogExit(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PoroPoro cảnh báo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có thực sự muốn thoát'),
              ], //text body cua dialog
            ), // listbody
          ), // singleChildScrollView
          actions: <Widget>[
            FlatButton(
              child: Text('Huỷ bỏ'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Thoát'),
              onPressed: () async {
//                await _handleSignOut(
//                    context); // goi phuong thuc handle sign out
//                Navigator.of(context).pop(true);
                SystemNavigator.pop();
//                onPressed: () => SystemNavigator.pop(),
              }, //add them action cho button
            ),
          ],
        ); //alert dialog
      },
    );
  }
}
