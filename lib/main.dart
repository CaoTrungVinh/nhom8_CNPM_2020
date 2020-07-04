import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: Text(
          'PoroPoro',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),

        backgroundColor: Colors.white,
        actions: [
//            new ListTile( title: new Text("Cài đặt",),),
          new IconButton(
            icon: new Icon(
              Icons.settings, color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Center(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new FlatButton(
//                        color: const Color(0xffF7A36F),
//                        textColor: Colors.white,
//                        disabledColor: Colors.grey,
//                        disabledTextColor: Colors.black,
//                        padding: EdgeInsets.all(8.0),
//                        splashColor: Colors.blueAccent,
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
              new FlatButton(
                onPressed: ()=> SystemNavigator.pop(),
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
    ));
  }
}

class Setting extends StatelessWidget {
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
      body: Center(
//        child: RaisedButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: Text('Go back!'),
//        ),
          ),
    );
  }
}

const String _name = "Vĩnh";

class ChatScreen extends StatefulWidget {
  //modified
  @override //new
  State createState() => new ChatScreenState(); //new
}

class Message {
  final int id;
  final bool isMy;
  final DateTime createdAt;
  final String content;

  Message({
    this.isMy,
    this.id,
    this.createdAt,
    this.content,
  });
}

// Add the ChatScreenState class definition in main.dart.
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Message> _messages = <Message>[
    Message(
      id: 0,
      isMy: false,
      createdAt: DateTime.now(),
      content: "A",
    ),
    Message(
      id: 1,
      isMy: true,
      createdAt: DateTime.now(),
      content: "hello",
    ),
  ];
  TextEditingController _textController;
  String _text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xff2E3A59),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        'Nói chuyện',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          thickness: 1,
          color: Color(0xffE4E9F2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = _messages[_messages.length - index - 1];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: message.isMy
                            ? _buildMyMessage(context, message)
                            : _buildTheirMessage(context, message),
                      );
                    },
                    reverse: true,
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.mic,
                        color: Color(0xff1654B4),
                      ),
                      onTap: () async {},
                    ),
                    SizedBox(width: 16),
                    Expanded(
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
                          hintText: 'Nhập nội dung...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff8F9BB3),
                          ),
                          suffixIcon: GestureDetector(
                            child: new Icon(Icons.send),
                            onTap: _text != null && _text.isNotEmpty
                                ? () => onSubmit()
                                : null,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        cursorColor: Color(0xffE4E9F2),
                        maxLines: 3,
                        minLines: 1,
                        controller: _textController,
                        onChanged: (value) => setState(() {
                          _text = value;
                        }),
                        onFieldSubmitted: (val) => onSubmit(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyMessage(BuildContext context, Message message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          DateFormat('dd/MM/yyyy HH:mm').format(message.createdAt),
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: <Widget>[
            Expanded(child: SizedBox(width: 60)),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xffF0F5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
              constraints: BoxConstraints(
                minHeight: 40,
                minWidth: 40,
                maxWidth: MediaQuery.of(context).size.width - 60,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTheirMessage(BuildContext context, Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
            'https://api.adorable.io/avatars/285/abott@adorable.png',
          ),
          radius: 18,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(message.createdAt),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border.all(
                        color: Color(0xffE0E0E0),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                    ),
                    constraints: BoxConstraints(
                      minHeight: 40,
                      minWidth: 40,
                      maxWidth: MediaQuery.of(context).size.width - 60,
                    ),
                  ),
                  Expanded(child: SizedBox(width: 60)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onSubmit() {
    if (_text != null && _text.isNotEmpty) {
      setState(() {
        _messages.add(Message(
          content: _textController.text,
          isMy: true,
          createdAt: DateTime.now(),
        ));
        _text = null;
        _textController.clear();
      });
    }
  }
}
