import 'package:finonex_task/main.dart';
import 'package:finonex_task/ui/_ui.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const RepaintBoundary(
          child: ConnectivityIndicator(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final token = await modelDeps.authModel.getToken();
              print(token);
            },
            child: const Text('login'),
          ),
        ],
      ),
      body: const InstrumentsContainer(),
    );
  }
}
