import 'dart:math';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class GoogleAPI {
  // bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "vi_VN";
  final SpeechToText speech = SpeechToText();

  GoogleAPI() {
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    // if (hasSpeech) {
    //   _localeNames = await speech.locales();

    //   var systemLocale = await speech.systemLocale();
    //   _currentLocaleId = systemLocale.localeId;
    // }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Speech to Text Example'),
  //       ),
  //       body: Column(children: [
  //         Center(
  //           child: Text(
  //             'Speech recognition available',
  //             style: TextStyle(fontSize: 22.0),
  //           ),
  //         ),
  //         Container(
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   FlatButton(
  //                     child: Text('Initialize'),
  //                     onPressed: _hasSpeech ? null : initSpeechState,
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   FlatButton(
  //                     child: Text('Start'),
  //                     onPressed: !_hasSpeech || speech.isListening
  //                         ? null
  //                         : startListening,
  //                   ),
  //                   FlatButton(
  //                     child: Text('Stop'),
  //                     onPressed: speech.isListening ? stopListening : null,
  //                   ),
  //                   FlatButton(
  //                     child: Text('Cancel'),
  //                     onPressed: speech.isListening ? cancelListening : null,
  //                   ),
  //                 ],
  //               ),
  //               // Row(
  //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               //   children: <Widget>[
  //               //     DropdownButton(
  //               //       onChanged: (selectedVal) => _switchLang(selectedVal),
  //               //       value: _currentLocaleId,
  //               //       items: _localeNames
  //               //           .map(
  //               //             (localeName) => DropdownMenuItem(
  //               //               value: localeName.localeId,
  //               //               child: Text(localeName.name),
  //               //             ),
  //               //           )
  //               //           .toList(),
  //               //     ),
  //               //   ],
  //               // )
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           flex: 4,
  //           child: Column(
  //             children: <Widget>[
  //               Center(
  //                 child: Text(
  //                   'Recognized Words',
  //                   style: TextStyle(fontSize: 22.0),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Stack(
  //                   children: <Widget>[
  //                     Container(
  //                       color: Theme.of(context).selectedRowColor,
  //                       child: Center(
  //                         child: Text(
  //                           lastWords,
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                     Positioned.fill(
  //                       bottom: 10,
  //                       child: Align(
  //                         alignment: Alignment.bottomCenter,
  //                         child: Container(
  //                           width: 40,
  //                           height: 40,
  //                           alignment: Alignment.center,
  //                           decoration: BoxDecoration(
  //                             boxShadow: [
  //                               BoxShadow(
  //                                   blurRadius: .26,
  //                                   spreadRadius: level * 1.5,
  //                                   color: Colors.black.withOpacity(.05))
  //                             ],
  //                             color: Colors.white,
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(50)),
  //                           ),
  //                           child: IconButton(icon: Icon(Icons.mic)),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: Column(
  //             children: <Widget>[
  //               Center(
  //                 child: Text(
  //                   'Error Status',
  //                   style: TextStyle(fontSize: 22.0),
  //                 ),
  //               ),
  //               Center(
  //                 child: Text(lastError),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           padding: EdgeInsets.symmetric(vertical: 20),
  //           color: Theme.of(context).backgroundColor,
  //           child: Center(
  //             child: speech.isListening
  //                 ? Text(
  //                     "I'm listening...",
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   )
  //                 : Text(
  //                     'Not listening',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //           ),
  //         ),
  //       ]),
  //     ),
  //   );
  // }

  Future startListening() async {
    print("vô start: ....");
    lastWords = "";
    lastError = "";
    return speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: false,
        onDevice: true,
        listenMode: ListenMode.confirmation);
  }

  Future stopListening() async {
    print("stop");
    return speech.stop();
  }

  void cancelListening() async {
    return speech.cancel();
  }

  void resultListener(SpeechRecognitionResult result) {
    print("resultListener");
    lastWords = result.recognizedWords;
    print('GAN $lastWords');
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    lastError = "${error.errorMsg} - ${error.permanent}";
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    lastStatus = "$status";
  }

  // _switchLang(selectedVal) {
  //   setState(() {
  //     _currentLocaleId = selectedVal;
  //     print(_currentLocaleId);
  //   });
  //   print(selectedVal);
  // }
}
