import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authenrication_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //Thực hiện khởi tạo app

    // tu dong login tk da dang nhapo truoc do
    await context.read<AuthenticationProvider>().autoLogin();

    //Vào màn hình chính
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("assets/images/logo1.png"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "PoroPoro",
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.black,
              strokeWidth: 5,
            )
          ],
        ),
      ),
    );
  }
}
