import 'package:finonex_task/main.dart';
import 'package:finonex_task/models/auth/model/auth_state.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        switch (modelDeps.authModel.stateStream.value) {
          AuthState.noUser => const Icon(
            Icons.output_rounded,
            color: Colors.redAccent,
          ),
          AuthState.user => const Icon(
            Icons.input_rounded,
            color: Colors.green,
          ),
        },
        IconButton(
          icon: Icon(Icons.input_rounded),
          onPressed: () {
            modelDeps.authModel.login();
          },
        ),
        IconButton(
          icon: Icon(Icons.output_rounded),
          onPressed: () {
            modelDeps.authModel.logout();
          },
        ),
      ],
    );
  }
}
