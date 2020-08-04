import 'dart:io';

import 'package:appchat/src/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'setting_screen.dart';
import 'login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
GoogleSignInAccount _currentUser;
bool isSignIn = false;

//class HomeScreen extends StatelessWidget {
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homeScreen();
  }
}
// trang chủ
class _homeScreen extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_currentUser != null) {
      setState(() {
        isSignIn = true;
      });
    } else {
      setState(() {
        isSignIn = false;
      });
    }
  }

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
//             ListTile( title:  Text("Cài đặt",),),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
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
            children: [//nếu đã đăng nhập thì hiển thị tên tài khoản
              isSignIn
                  ? FlatButton(
                      onPressed: () {
                      },
                      child: Text(
                        _currentUser.displayName ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : FlatButton(// nếu chưa đăng nhập hiển thị đăng nhập
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
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
              FlatButton(
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
              FlatButton(
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
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginScreen();
  }
}

class _loginScreen extends State<LoginScreen> {
  @override

  //lắng nghe tài khoản google đăng nhập trả về thông tin tài khoản
  void initState() {
    // TODO: implement initState
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  void initState1() {
    // TODO: implement initState
    super.initState();
    if (_currentUser != null) {
      setState(() {
        isSignIn = true;
      });
    } else {
      setState(() {
        isSignIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {//đăng nhập thành công trở về home

    } else { // đăng nhập thất bại gọi đăng nhập
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image(
              image: AssetImage("assets/images/logo_chat.png"), height: 150.0),
          OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              _handleSignIn();
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
//          RaisedButton(
//            onPressed: _handleSignIn,
//            child: Text('SIGN IN'),
//          )
        ],
      );
    }
  }
  // đăng nhập tài khoản
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    setState(() {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new HomeScreen()));
    });
  }
}

///cài đặt
class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MySettingState();
  }
}

//hàm build
class _MySettingState extends State<SettingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

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
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: [
                      isSignIn
                          ? ListTile(
                              leading: GoogleUserCircleAvatar(
                                identity: _currentUser,
                              ),
                              title: Text(_currentUser.displayName ?? ''),
                              subtitle: Text(_currentUser.email ?? ''),
                            )
                          : ListTile(
                              title: Text('PoroPoro chào bạn'),
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 350, 30, 0),
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
                          onPressed: _showDialog,
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
          )),
    );
  }
//them mot dialog hoi nguoi dung co muon dang xuat that hay khong
  Future<void> _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cảnh báo đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('bạn có thực sự muốn đăng xuất khỏi phiên làm việc'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Đồng ý'),
              onPressed: () {
                _handleSignOut();
                Navigator.of(context).pop();
              } ,
            ),
            FlatButton(
              child: Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
    setState(() {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new HomeScreen()));
    });
  }
}
