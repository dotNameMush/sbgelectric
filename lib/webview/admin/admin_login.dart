import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sbgelectric/core/shared/shared.dart';
import 'package:sbgelectric/webview/admin/admin_panel.dart';

import '../../core/app_core/auth.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return const AdminScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color(0xFF004882)),
        child: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logotext.png'),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text('Нэвтрэх',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.indigo,
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'И-Мэйл',
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'И-Мэйл буруу байна'
                                  : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: !_passwordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (value) {
                            signIn();
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.indigo,
                              ),
                              border: const OutlineInputBorder(),
                              labelText: 'Нууц үг',
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? '6-аас олон тэмдэгт оруулна уу?'
                                  : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: signIn,
                          child: Container(
                            padding: const EdgeInsets.all(17),
                            width: MediaQuery.of(context).size.width / 5 * 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFF004882),
                            ),
                            child: const Center(
                              child: Text(
                                'Нэвтрэх',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
