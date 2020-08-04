import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:appchat/src/models/google_assistant_api.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/generated/google/assistant/embedded/v1alpha2/embedded_assistant.pbgrpc.dart'
    hide SpeechRecognitionResult;
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// state: trạng thái giao diện, khi thuộc tính nào đó thay đổi thì giao diện sẽ thay đổi theo
class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = []; // ds tin nhắn
  TextEditingController
      _controller; //controller của text editor nhập chữ bằng ban phím, lấy ra text nhập
  GoogleAssistantAPI _assistant; // model of google
  SpeechToText _speech = SpeechToText();
  bool _isInitializing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isInitializing = true;
    _controller = TextEditingController();
    _init();
  }

  void _init() async {
    await _initGoogleAssistant();
    await _speech.initialize(onError: showError);
    await showMess();

    setState(() {
      _isInitializing = false;
    });
  }

  Future showMess() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final messageData = prefs.getString("messages");
    if (messageData != null && messageData.isNotEmpty) {
      final messages = jsonDecode(messageData) as List;
      for (var mess in messages) {
        _messages.add(Message.fromJson(mess));
      }
    }
  }

  // thêm tin nhắn của API lên màn hình chat và save local
  Future<void> _addTheirMessage(String text) async {
    final Message message = Message(
      content: text,
      isMine: false,
      createdAt: DateTime.now(),
    );
    _addMessage(message);
  }

  // thêm tin nhắn của nguoiwf dungf lên màn hình chat và save local
  Future<void> _addMyMessage(String text) async {
    final Message message = Message(
      content: text,
      isMine: true,
      createdAt: DateTime.now(),
    );
    _addMessage(message);
  }

// thêm tin nhắn lên màn hình chat và save local
  Future<void> _addMessage(Message message) async {
    setState(() {
      _messages.add(message);
    });
    // save mess local
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "messages", jsonEncode(_messages.map((m) => m.toJson()).toList()));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Chat'),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isInitializing) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
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
                    child: message.isMine
                        ? _buildMyMessage(message)
                        : _buildTheirMessage(message));
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
                onTap: () async {
                  if (!_speech.isListening) {
                    await _speech.listen(
                      onResult: _onTextReg,
                      listenFor: Duration(seconds: 10),
                      localeId: "vi-VN",
                      cancelOnError: true,
                      partialResults: false,
                      onDevice: true,
                      listenMode: ListenMode.confirmation,
                    );
                  }
                },
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _controller,
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
                      child: Icon(Icons.send),
                      onTap: () {
                        _sendTextMessage();
                      },
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  cursorColor: Color(0xffE4E9F2),
                  maxLines: 3,
                  minLines: 1,
                  onFieldSubmitted: (value) {
                    _sendTextMessage();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyMessage(Message message) {
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
            Expanded(child: SizedBox(width: 120)),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 120,
              ),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTheirMessage(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/logo_chat.png'),
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
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 120,
                    ),
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
                  ),
                  Expanded(child: SizedBox(width: 120)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // phat ra audio
  void playAudio(List<int> audioData) {
    if (audioData.length > 0) {
      Audio.loadFromByteData(
          ByteData.sublistView(Uint8List.fromList(audioData)))
        ..play()
        ..dispose();
    }
  }

  Future<void> _initGoogleAssistant() async {
    _assistant = GoogleAssistantAPI(
      onAudio: playAudio,
      onText: _addTheirMessage,
    );
    await _assistant.init();
  }

  //Xử  lý text trả về từ speech_regconize
  void _onTextReg(SpeechRecognitionResult result) {
    _addMyMessage(result.recognizedWords);
    _assistant.processing(result.recognizedWords);
  }

  //Xử lý text người dùng nhập vào
  void _sendTextMessage() {
    if (_controller.text.isNotEmpty) {
      String text = _controller.text;
      _controller.clear();
      _assistant.processing(text);
    }
  }

  //Hiển thị lỗi
  void showError(SpeechRecognitionError errorNotification) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(errorNotification.errorMsg),
      ),
    );
  }
}
