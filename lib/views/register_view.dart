// RegisterView
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import 'package:learnflutter/constants/routes.dart';
import 'package:learnflutter/utilites/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
              final email = _email.text;
              final password = _password.text;

              try {
                // final userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // devtools.log(userCredential.toString());

                /// The user will get verification email upon pressing the register
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                // Navigating to the VerifyEmailView();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                // devtools.log("Something went wrong: ${e.code}");
                if (e.code == 'weak-password') {
                  await showErrorDialog(
                    context,
                    'Weak password',
                  );
                  // devtools.log("Weak Password");
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                    context,
                    'Email is already in use',
                  );
                  // devtools.log("Email is already in use");
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                    context,
                    'This is an invalid email address',
                  );
                  // devtools.log("Invalid email entered");
                } else {
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  // e.toString(),
                  "Error (0x00r0): $e",
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
