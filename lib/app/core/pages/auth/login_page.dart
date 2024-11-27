import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:vagas/app/core/pages/auth/Controllers/login_controller.dart';

import 'package:vagas/app/core/utils.dart';

class LoginPage extends StatefulWidget {
  static const String name = 'login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _loginController = LoginController(auth: auth, firestore: firestore);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login Controle de Vagas Taparuba'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "Email",
                  style: TextStyle(color: Color(0xFF707070), fontSize: 18),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "exemplo@email.com",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF707070)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF707070)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Senha",
                  style: TextStyle(color: Color(0xFF707070), fontSize: 18),
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira algum texto';
                    }
                    if (value.length < 6) {
                      return "Senha muito curta";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "********",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF707070)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF707070)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          EasyLoading.show(status: 'Fazendo Login...');
                          await _loginController.signIn(
                              _emailController.text, _passwordController.text);
                          context.go('/home-page');
                          EasyLoading.dismiss();
                        } catch (error) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error.toString()),
                          ));
                        }
                      }
                    },
                    child: Text('ENTRAR'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
