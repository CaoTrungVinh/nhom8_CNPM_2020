import 'dart:async';
import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:intl/intl.dart';
import 'package:mic_stream/mic_stream.dart';

import '../models/generated/google/assistant/embedded/v1alpha2/embedded_assistant.pbgrpc.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat_screen';

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
  EmbeddedAssistantClient _assistant; //
  Stream<List<int>> _audioStream;
  bool _isRecording = false;
  List<int> _lastConversationState;

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
    _controller = TextEditingController();
    _initGoogleAssistant();
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Chat'),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
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
                onLongPress: () {
                  _audioStream = microphone(
                    audioSource: AudioSource.DEFAULT,
                    sampleRate: 16000,
                    channelConfig: ChannelConfig.CHANNEL_IN_MONO,
                    audioFormat: AudioFormat.ENCODING_PCM_16BIT,
                  );

                  print("Start Listening to the microphone");
                  _isRecording = true;
                  final conversation = _sendAudioMessage();
                  _handleAssistResponse(conversation);
                },
                onLongPressEnd: (details) {
                  _isRecording = false;
                  _audioStream = null;
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

  AssistRequest _createAssistRequest([String text]) {
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

    final DebugConfig debugConfig = DebugConfig()..returnDebugInfo = true;

    final config = AssistConfig()
      ..audioOutConfig = audioOutConfig
      ..deviceConfig = deviceConfig
      ..dialogStateIn = dialogStateIn
      ..debugConfig = debugConfig;

    if (text == null) {
      final audioInConfig = AudioInConfig()
        ..encoding = AudioInConfig_Encoding.LINEAR16
        ..sampleRateHertz = 16000;
      config.audioInConfig = audioInConfig;
    } else {
      config.textQuery = text;
    }

    final request = AssistRequest()..config = config;
    return request;
  }

  void _handleAssistResponse(Stream<AssistResponse> conversation) async {
    List<int> audioData = List();

    await conversation.forEach((response) {
      print(response.eventType);
      print(response.audioOut);
      print(response.screenOut);
      print(response.deviceAction);
      print(response.speechResults);
      print(response.dialogStateOut);
      print(response.debugInfo);
      audioData.addAll(response.audioOut.audioData);
      if (response.dialogStateOut != null) {
        if (response.dialogStateOut.conversationState != null) {
          _lastConversationState = response.dialogStateOut.conversationState;
        }
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

    if (audioData.length > 0) {
      Audio.loadFromByteData(
          ByteData.sublistView(Uint8List.fromList(audioData)))
        ..play()
        ..dispose();
    }
  }

  void _addMessage(Message message) {
    setState(() {
      _messages.add(message);
    });

    //TODO: Lưu _messages xuống local storage
  }

  void _initGoogleAssistant() async {
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

  Stream<AssistResponse> _sendAudioMessage() {
    if (_audioStream != null) {
      Stream<AssistRequest> stream(Stream<List<int>> _audioStream) async* {
        yield _createAssistRequest(null);
        print('yield start');
        await for (List<int> data in _audioStream) {
          if (_isRecording) {
            print('yield data');
            yield AssistRequest()..audioIn = data;
          } else {
            break;
          }
        }
      }

      return _assistant.assist(stream(_audioStream));
    }

    return null;
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
}
