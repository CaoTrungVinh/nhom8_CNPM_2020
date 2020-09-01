import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authenrication_provider.dart';
import 'home_screen.dart';

///cài đặt
//2. hiển thị giao diện setting
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
          ), //phong chu, mau ,kich co cho title
        ), // title cho app bar
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff2E3A59),
          ), //dinh hinh cho icon va mau sac
          onPressed: () {
            Navigator.of(context).pop();
          }, // them action icon back
        ),
        backgroundColor: Colors.white,
      ), // app bar setting
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
            ), //padding 1
            context.watch<AuthenticationProvider>().isSignedIn
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 400, 30, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: RaisedButton(
                            color: Color(0xff1654B4),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            onPressed: () async {
                              final res = await _showDialog(
                                  context); // 4.Hiển thị dialog hỏi người dùng có muốn đăng xuất
                              if (res == true) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen(),
                                    //10b.Hiển thị trang chủ của ứng dụng sau khi đăng xuất
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Đăng xuất",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) //padding 2 - 3. chọn button đăng xuất
                : ListTile(
                    title: Text(''),
                  )
          ], // childrens
        ), // child columns
      ), //body
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
              ], //text body cua dialog
            ), // listbody
          ), // singleChildScrollView
          actions: <Widget>[
            FlatButton(
              child: Text('Huỷ bỏ'), // 5a.người dùng lựa chọn hủy bỏ
              onPressed: () {
                Navigator.of(context).pop(false);
              }, //add them action cho button
            ), //button huy bo
            FlatButton(
              child: Text('Đăng xuất'),
              //5b. người dùng lựa chọn đồng ý đăng xuất
              onPressed: () async {
                await _handleSignOut(
                    context); // goi phuong thuc handle sign out
                Navigator.of(context).pop(true);
              }, //add them action cho button
            ), // button dang xuat
          ], //list cac actions gom 2 button
        ); //alert dialog
      },
    );
  } // day la mot dialog hoi nguoi dung co muon dang xuat

  Future<void> _handleSignOut(BuildContext context) async {
    await context.read<AuthenticationProvider>().logout();
  } // goi phuong thuc logout() tu class authenticationProvider - 6b. yêu cầu api googleSignIn hủy bỏ access token
}
