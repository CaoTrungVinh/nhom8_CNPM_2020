import 'dart:convert';

import 'package:grpc/grpc.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'generated/google/assistant/embedded/v1alpha2/embedded_assistant.pbgrpc.dart';

enum TextType {
  HTML,
  PLAIN,
}

class GoogleAssistantAPI {
  final void Function(String text, TextType type)
      onText; // hàm trả kết quả text ra ngoài
  final void Function(List<int> audio)
      onAudio; // hàm trả kết quả audio ra ngoài

  EmbeddedAssistantClient _assistant;
  List<int>
      _lastConversationState; // conversationState của câu trả lời trước đó.

  GoogleAssistantAPI({
    this.onText,
    this.onAudio,
  });

  Future<void> init() async {
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

  AssistRequest _createAssistRequest(String text) {
    final audioOutConfig = AudioOutConfig()
      ..encoding = AudioOutConfig_Encoding.MP3
      ..sampleRateHertz = 24000
      ..volumePercentage = 100;

    final deviceConfig = DeviceConfig()
      ..deviceId = 'default'
      ..deviceModelId = 'assitant-d01338a2e907e-8567-4b06-9c38-049527d47c3e';

    final dialogStateIn = DialogStateIn()..languageCode = 'en_US';
    if (_lastConversationState != null) {
      dialogStateIn.conversationState = _lastConversationState;
    }

    final screenOutConfig = ScreenOutConfig()
      ..screenMode = ScreenOutConfig_ScreenMode.OFF;

    final config = AssistConfig()
      ..audioOutConfig = audioOutConfig
      ..deviceConfig = deviceConfig
      ..dialogStateIn = dialogStateIn
      ..screenOutConfig = screenOutConfig;

    config.textQuery = text;

    final request = AssistRequest()..config = config;
    return request;
  }

  // 3. API xử lý dữ liệu và  trả về kết quả:
  // processing(String text);
  void processing(String text) {
    if (_assistant == null) return;

    if (text != null && text.isNotEmpty) {
      final request = _createAssistRequest(text);
      Stream<AssistResponse> responseStream =
          _assistant.assist(Stream.value(request));
      _handleAssistResponse(responseStream);
    }

    return null;
  }

  void _handleAssistResponse(Stream<AssistResponse> conversation) async {
    List<int> audioData = List();
    List<int> htmlData = List();
    String text;

    await conversation.forEach((response) {
      print(response.eventType);
      print(response.audioOut);
      print(response.screenOut); // đoạn html của dữ liệu trả về
      print(response.deviceAction); // dieu khien thiet bi
      print(response.speechResults); // text in speech to text
      print(response.dialogStateOut); // co chua text maf gg tra ve
      print(response.debugInfo);

      //Lấy audio data
      audioData.addAll(response.audioOut.audioData);

      //Lấy dữ liệu HTML nếu có
      if (response.screenOut != null && response.screenOut.data != null) {
        htmlData.addAll(response.screenOut.data);
      }

      if (response.dialogStateOut != null) {
        if (response.dialogStateOut.conversationState != null) {
          _lastConversationState = response.dialogStateOut.conversationState;
        }
        // supplementalDisplayText du lieu text ma gg tra ve
        if (response.dialogStateOut.supplementalDisplayText != null &&
            response.dialogStateOut.supplementalDisplayText.isNotEmpty) {
          print("BHGHHBHBHB");
          text = response.dialogStateOut.supplementalDisplayText.trim();
        }
      }
    });
    // phat audio gg tra ve
    if (onAudio != null && audioData.length != 0) {
      onAudio(audioData);
    }

    if (onText != null) {
      if (text != null && text.isNotEmpty) {
        onText(
          text,
          TextType.PLAIN,
        );
      } else if (htmlData.length != 0) {
        // print(utf8.decode(htmlData));
        onText(
          utf8.decode(htmlData),
          TextType.HTML,
        );
      }
    }
  }
}
