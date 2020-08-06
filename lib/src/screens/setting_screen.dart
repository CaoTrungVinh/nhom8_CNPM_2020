import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authenrication_provider.dart';
import 'home_screen.dart';

///cài đặt
class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  context.watch<AuthenticationProvider>().isSignedIn
                      ? ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              context
                                  .watch<AuthenticationProvider>()
                                  .currentUser
                                  .photoUrl,
                            ),
                          ),
                          title: Text(context
                                  .watch<AuthenticationProvider>()
                                  .currentUser
                                  .displayName ??
                              ''),
                          subtitle: Text(context
                                  .watch<AuthenticationProvider>()
                                  .currentUser
                                  .email ??
                              ''),
                        )
                      : ListTile(
                          title: Text('PoroPoro chào bạn'),
                        )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 400, 30, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: RaisedButton(
                      color: Color(0xff1654B4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onPressed: () async {
                        final res = await _showDialog(context);
                        if (res == true) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Đăng xuất",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//them mot dialog hoi nguoi dung co muon dang xuat that hay khong
  Future<bool> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cảnh báo đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có thực sự muốn đăng xuất khỏi phiên làm việc'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Huỷ bỏ'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Đăng xuất'),
              onPressed: () async {
                await _handleSignOut(context);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await context.read<AuthenticationProvider>().logout();
  }
}
