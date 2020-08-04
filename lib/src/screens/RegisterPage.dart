
import 'package:flutter/material.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 140,
              ),
              Image.asset('logo.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 6),
                child: Text(
                  "Begining To PoroPoro!",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Name",
                          prefixIcon: Container(
                              width: 50, child: Image.asset("ic_user.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                ),
              ),

                 TextFormField(
                   validator: (String arg) {
                     if(arg.length < 3)
                       return 'Name must be more than 2 charater';
                     else
                       return null;
                   },
                   onSaved: (String val) {
                     _name = val;
                   },
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Container(
                            width: 50, child: Image.asset("ic_phone.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
               child: TextField(

                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Container(
                              width: 50, child: Image.asset("ic_mail.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                 ),
              ),

                  TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(

                        labelText: "Password",
                        prefixIcon: Container(
                            width: 50, child: Image.asset("ic_lock.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Re_Password",
                      prefixIcon: Container(
                          width: 50, child: Image.asset("ic_lock.png")),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xffCED0D2), width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    child: Text(
                      "Signup",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Color(0xff3277D8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: RichText(
                  text: TextSpan(
                      text: "Already a User? ",
                      style: TextStyle(color: Color(0xff606470), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Login now",
                            style: TextStyle(
                                color: Color(0xff3277D8), fontSize: 16))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
