import 'package:grpc/grpc.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'generated/google/assistant/embedded/v1alpha2/embedded_assistant.pbgrpc.dart';

class GoogleAssistantAPI {
  final void Function(String text) onText; // hàm trả kết quả text ra ngoài
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
          if (onText != null) {
            onText(response.dialogStateOut.supplementalDisplayText);
          }
        }
      }
    });
    // phat audio gg tra ve
    if (onAudio != null) {
      onAudio(audioData);
    }
  }
}
