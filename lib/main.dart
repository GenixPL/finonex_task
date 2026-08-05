import 'package:finonex_task/deps/_deps.dart';
import 'package:finonex_task/deps/model_deps_factory.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

late ModelDeps modelDeps;

void main() {
  final RunMode runMode = RunMode.live;

  modelDeps = switch (runMode) {
    RunMode.live => ModelDepsFactory.live(),
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.grey,
        ),
        useMaterial3: true,
      ),
      home: const MyHomeScreen(),
    );
  }
}
