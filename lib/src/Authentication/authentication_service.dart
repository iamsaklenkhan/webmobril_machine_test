import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webmobril_test/src/screen/home/view/home_view.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get user => _firebaseAuth.currentUser;
  bool isLoding = false;

  Future<void> signInWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    isLoding = true;
    notifyListeners();
    try {
      final data = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (data.user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
    }
    isLoding = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    notifyListeners();
  }

  Future<void> registerWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    isLoding = true;
    notifyListeners();
    try {
      final data = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (data.user != null) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Error registering: $e');
      }
    }
    isLoding = false;
    notifyListeners();
  }
}
