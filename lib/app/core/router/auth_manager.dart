import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  final FirebaseAuth auth;

  AuthManager({required this.auth});

  Future<bool> isAuthenticated() async {
    return await auth.currentUser?.uid != null;
  }
}
