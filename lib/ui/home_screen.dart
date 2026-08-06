import 'package:finonex_task/main.dart';
import 'package:finonex_task/ui/auth_widget/auth_widget.dart';
import 'package:finonex_task/ui/connectivity_indicator/connectivity_indicator.dart';
import 'package:finonex_task/ui/instrument_container/instrument_container.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const RepaintBoundary(
          child: ConnectivityIndicator(),
        ),
        actions: const [
          AuthWidget(),
        ],
      ),
      body: const SafeArea(
        child: InstrumentsContainer(),
      ),
    );
  }
}
