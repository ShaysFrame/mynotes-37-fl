// LoginView
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:learnflutter/constants/routes.dart';
import 'package:learnflutter/utilites/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Class Variables
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),
          TextButton(
            onPressed: () async {
              /// You don't need the following initilizatin because
              /// it's been already initialized in the Future Builder
              ///
              // await Firebase.initializeApp(
              //   options: DefaultFirebaseOptions.currentPlatform,
              // );
              final email = _email.text;
              final password = _password.text;

              try {
                // final userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // devtools.log(userCredential.toString());
                // userCredential is object and can't be
                //logged without .toString()
                // devtools.log("UserCredentials: $userCredential");
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                // devtools.log("Specified Exception: ");

                if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                  await showErrorDialog(
                    context,
                    "Wrong user credentials",
                  );
                  // devtools.log(
                  //   "User not found/Wrong Password/ Invalid login credentials",
                  // );
                } else {
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}',
                  );
                  // devtools.log(e.code);
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  'Error (0x00l0): $e',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
                // false means remove every other screen behind.
              );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
