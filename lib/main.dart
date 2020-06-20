import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: new Text("PoroPoro"),
        backgroundColor: const Color(0xff00DFEE),
        actions: [
//            new ListTile( title: new Text("Cài đặt",),),
          new IconButton(
            icon: new Icon(
              Icons.settings,
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
                    MaterialPageRoute(builder: (context) => MyAppChat()),
                  );
                },
                child: Text(
                  "Nói chuyện",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              new FlatButton(
//                        color: Colors.blue,
//                        textColor: Colors.white,
//                        disabledColor: Colors.grey,
//                        disabledTextColor: Colors.black,
//                        padding: EdgeInsets.all(8.0),
//                        splashColor: Colors.blueAccent,
                onPressed: () {
                  /*...*/
                },
                child: Text(
                  "Thoát",
                  style: TextStyle(fontSize: 20.0),
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
        title: Text("Cài đặt"),
        backgroundColor: const Color(0xff00DFEE),
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

class MyAppChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",

      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  //modified
  @override //new
  State createState() => new ChatScreenState(); //new
}

// Add the ChatScreenState class definition in main.dart.
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  ScrollController _controller;

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      //"reach the bottom"
      setState(() {});
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      // "reach the top";
      setState(() {});
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black38),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

  Widget _buildTextInput() => Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.only(left: 8.0),
        decoration: myBoxDecoration(),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                minLines: 1,
                decoration:
                    new InputDecoration.collapsed(hintText: "Nhập tin nhắn"),
              ),
            ),
            new Container(
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null),
            ),
          ],
        ),
      );

  Widget _buildTextComposer() {
    return new IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: new IconButton(
                icon: new Icon(Icons.mic),
                onPressed: () => _handleTouchOnMic()),
          ),

          Expanded(
            child: _buildTextInput(),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    if (text.length > 0) {
      ChatMessage message = new ChatMessage(
        text: text,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 700),
          vsync: this,
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    }
  }

  void _handleTouchOnMic() {}


  @override //new
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(backgroundColor: const Color(0xff00DFEE),
        actions: [
          new IconButton(
            icon: new Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          )
        ],
        title: new Text('Nói chuyện'),
      ),

      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              controller: _controller,
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          // new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: SafeArea(
              bottom: true,
              child: _buildTextComposer(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController}); //modified
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(left: 40.0),
//              color: const Color(0xff00DFEE),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                color: const Color(0xff00DFEE),
//                new Text(_name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: new Text(text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
