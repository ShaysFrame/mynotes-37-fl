// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:learnflutter/constants/routes.dart';
import 'package:learnflutter/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify email',
        ),
      ),
      body: Column(children: [
        const Text(
            "We've sent you an email verification. Please click on the link to verify your account."),
        const Text(
            "If you haven't received a verification email yet, press the button bellow"),
        TextButton(
          onPressed: () async {
            AuthService.firebase().sendEmailVerification();
            devtools.log("Verification Email Sent");
          },
          child: const Text(
            'Send email verification again',
          ),
        ),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text('Restart'),
        ),
      ]),
    );
  }
}
