import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  LoginController({required this.auth, required this.firestore});

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    auth.signOut();
  }
}
