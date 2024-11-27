import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vagas/app/core/router/app_router.dart';
import 'package:vagas/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    firestore = FirebaseFirestore.instance;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: EasyLoading.init(),
    );
  }
}
