import 'package:flutter/material.dart';

bool checkNMK = false;
bool _showPass = false;
TextEditingController _email = new TextEditingController();
TextEditingController _pass = new TextEditingController();
var _emailError = "Email không hợp lệ";
var _passError = "Mật khẩu không đúng";
var _emailEr = false;
var _passEr = false;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginScreen();
  }
}

//hàm build
class _loginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Đăng nhập/ Đăng ký',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Color(0xff2E3A59),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          // cách bên trái 30 bên phải 30 không để không sát biên quá
//          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.blue,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topEnd,
                      padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      child: FlatButton(
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  controller: _email,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                    labelText: "Email",
                      errorText: _emailEr ? _emailError : null,
                    labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Stack(
//                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    Container(
                      child: TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: _pass,
                        obscureText: _showPass,
                        decoration: InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            labelText: "Mật khẩu",
                            errorText: _passEr ? _passError : null,
                            labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: showPass,
                      child: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        padding: const EdgeInsets.fromLTRB(0, 30, 10, 0),
                        child: _showPass
                            ? Icon(Icons.remove_red_eye,
                                color: Color(0xff8F9BB3))
                            : Icon(Icons.remove_red_eye,
                                color: Color(0xff8F9BB3)),
//                        child: _showPass
//                            ? Icon(Icons.remove_red_eye,
//                                color: Color(0xff8F9BB3))
//                            : Icon(Icons.remove_red_eye,
//                                color: Color(0xff8F9BB3)),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                child: Stack(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: checkNMK,
                      onChanged: (bool value) {
                        setState(() {
                          checkNMK = value;
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                      child: Text("Nhớ mật khẩu"),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: RaisedButton(
                    color: Color(0xff1654B4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: xuLyLogin,
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Center(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                        color: Color(0xff4374C2),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Stack(
                  children: [
                    Center(
                      child: Text("Hoặc đăng nhập với"),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
                      child: RaisedButton(
                        color: Color(0xff1654B4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: xuLyLogin,
                        child: Text(
                          "F",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topEnd,
                      padding: const EdgeInsets.fromLTRB(0, 20, 50, 0),
                      child: OutlineButton(
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: xuLyLogin,
                        child: Text(
                          "G",
                          style:
                              TextStyle(color: Color(0xffE93627), fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void xuLyLogin() {
    setState(() {
      if (_email .text.length < 6 || !_email.text.contains("@")){
        _emailEr = true;
      }else{
        _emailEr = false;
      }
    });
  }
}
