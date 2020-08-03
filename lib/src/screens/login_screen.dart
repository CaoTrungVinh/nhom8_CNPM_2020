import 'package:flutter/material.dart';

bool checkNMK = false;
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
            ),//chon kieu cho tieu de
          ),//tieu de
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Color(0xff2E3A59),
            ),//icon cho button chuyen ve trang truoc
            onPressed: () {
              Navigator.of(context).pop();
            },//them action cho icon
          ),// icon tren app bar
          backgroundColor: Colors.white,
        ),//app bar
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
              ),//padding
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Stack(
                  children: [
                    Text("EMAIL",
                        style: TextStyle(
                          color: Color(0xff8F9BB3), fontSize: 14
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xffE4E9F2),
                                width: 1,
                              ),
                            ),
                            hintText: 'Email...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xff8F9BB3),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),//padding
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Stack(
//                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    Text("MẬT KHẨU",
                        style: TextStyle(
                          color: Color(0xff8F9BB3), fontSize: 14
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xffE4E9F2),
                                width: 1,
                              ),
                            ),
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xff8F9BB3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsets.fromLTRB(0, 30, 10, 0),
                      child: Icon(Icons.remove_red_eye, color: Color(0xff8F9BB3)),
                    )
                  ],
                ),
              ),//padding
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
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
              ),//padding
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
              ),//padding
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Center(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(color: Color(0xff4374C2), fontSize: 14,),
                    ),
                  ),
                ),
              ),//padding
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                      child: RaisedButton(
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: xuLyLogin,
                        child: Text(
                          "G",
                          style: TextStyle(color: Color(0xffE93627), fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),// child: columns
        ),//container
      ),//scafford
    );//material app
  }
}

void xuLyLogin() {}
