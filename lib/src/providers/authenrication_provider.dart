import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  GoogleSignInAccount _currentUser;
  bool _isSignedIn;

  GoogleSignInAccount get currentUser => _currentUser;
  bool get isSignedIn => _isSignedIn;

  AuthenticationProvider() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      _currentUser = account;
      _isSignedIn = await _googleSignIn.isSignedIn();
      notifyListeners();
    });
  }
  //vào lại nếu đã login thì k cần login lại
  Future<void> autoLogin() async {
    _currentUser = await _googleSignIn.signInSilently();
    _isSignedIn = await _googleSignIn.isSignedIn();
    notifyListeners();
  }
  //Gọi google login
  Future<void> login() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      _isSignedIn = await _googleSignIn.isSignedIn();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
