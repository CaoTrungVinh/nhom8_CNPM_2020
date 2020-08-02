import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser _user;
GoogleSignIn _googleSignIn = new GoogleSignIn();

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
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/logo_chat.png"),
                  height: 150.0),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    isSignIn = false;
  }
  Widget _signInButton() {
    return isSignIn
        ? OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              googleSignOut();
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
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user.photoUrl),
                  ),
                ],
              ),
            ),
          )
        : OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              handleSignIn();
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
          );
  }

  bool isSignIn = false;

  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    AuthResult result = (await _auth.signInWithCredential(credential));
    _user = result.user;
    setState(() {
      isSignIn = true;
    });
  }

  Future<void> googleSignOut() async {
    await _auth.signOut().then((value) {
      _googleSignIn.signOut();
      setState(() {
        isSignIn = false;
      });
    });
  }
}
