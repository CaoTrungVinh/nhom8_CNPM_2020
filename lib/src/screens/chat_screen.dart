import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
  EmbeddedAssistantClient _assistant; // model of google
  List<int>
      _lastConversationState; // conversationState của câu trả lời trước đó.
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
                        final conversation = _sendTextMessage();
                        _handleAssistResponse(conversation);
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
                    final conversation = _sendTextMessage();
                    _handleAssistResponse(conversation);
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

  AssistRequest _createAssistRequest(String text) {
    final audioOutConfig = AudioOutConfig()
      ..encoding = AudioOutConfig_Encoding.MP3
      ..sampleRateHertz = 24000
      ..volumePercentage = 100;

    final deviceConfig = DeviceConfig()
      ..deviceId = 'default'
      ..deviceModelId = 'default';

    final dialogStateIn = DialogStateIn()..languageCode = 'en-US';
    if (_lastConversationState != null) {
      dialogStateIn.conversationState = _lastConversationState;
    }

    final config = AssistConfig()
      ..audioOutConfig = audioOutConfig
      ..deviceConfig = deviceConfig
      ..dialogStateIn = dialogStateIn;

    config.textQuery = text;

    final request = AssistRequest()..config = config;
    return request;
  }

  void _handleAssistResponse(Stream<AssistResponse> conversation) async {
    List<int> audioData = List();

    await conversation.forEach((response) {
      print(response.eventType);
      print(response.audioOut);
      print(response.screenOut); // đoạn html của dữ liệu trả về
      print(response.deviceAction); // dieu khien thiet bi
      print(response.speechResults); // text in speech to text
      print(response.dialogStateOut); // co chua text maf gg tra ve
      print(response.debugInfo);
      audioData.addAll(response.audioOut.audioData);
      if (response.dialogStateOut != null) {
        if (response.dialogStateOut.conversationState != null) {
          _lastConversationState = response.dialogStateOut.conversationState;
        }
        // supplementalDisplayText du lieu text ma gg tra ve
        if (response.dialogStateOut.supplementalDisplayText != null &&
            response.dialogStateOut.supplementalDisplayText.isNotEmpty) {
          _addMessage(Message(
            content: response.dialogStateOut.supplementalDisplayText,
            isMine: false,
            createdAt: DateTime.now(),
          ));
        }
      }
    });
    // phat audio gg tra ve
    playAudio(audioData);
  }

  void playAudio(List<int> audioData) {
    if (audioData.length > 0) {
      Audio.loadFromByteData(
          ByteData.sublistView(Uint8List.fromList(audioData)))
        ..play()
        ..dispose();
    }
  }

  Future<void> _initGoogleAssistant() async {
    final scopes = [
      'https://www.googleapis.com/auth/assistant-sdk-prototype',
    ];
    final serviceAccount = await rootBundle.loadString('assets/key.json');

    final authenticator = ServiceAccountAuthenticator(
      serviceAccount,
      scopes,
    );

    final channel = ClientChannel('embeddedassistant.googleapis.com');
    _assistant = EmbeddedAssistantClient(
      channel,
      options: authenticator.toCallOptions,
    );
  }

  void _onTextReg(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    _addMessage(Message(
      isMine: true,
      content: result.recognizedWords,
      createdAt: DateTime.now(),
    ));
    final request = _createAssistRequest(result.recognizedWords);
    final conversation = _assistant.assist(Stream.value(request));
    _handleAssistResponse(conversation);
  }

  Stream<AssistResponse> _sendTextMessage() {
    if (_controller.text.isNotEmpty) {
      print('_controller.text not empty');
      if (_assistant != null) {
        print('_assistant not null');
        String text = _controller.text;
        _controller.clear();
        _addMessage(Message(
          content: text,
          isMine: true,
          createdAt: DateTime.now(),
        ));
        final request = _createAssistRequest(text);
        return _assistant.assist(Stream.value(request));
      }
    }
    return null;
  }

  void showError(SpeechRecognitionError errorNotification) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(errorNotification.errorMsg),
      ),
    );
  }
}
