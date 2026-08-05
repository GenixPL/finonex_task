import 'package:finonex_task/main.dart';
import 'package:finonex_task/services/_services.dart';
import 'package:flutter/material.dart';

class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityState>(
      stream: modelDeps.connectivityModel.stateStream,
      initialData: modelDeps.connectivityModel.stateStream.valueOrNull,
      builder: (context, snapshot) {
        final state = snapshot.data ?? ConnectivityState.unknown;

        return Icon(
          _getIcon(state),
          color: _getColor(state),
        );
      },
    );
  }

  IconData _getIcon(ConnectivityState state) {
    return switch (state) {
      ConnectivityState.connected => Icons.wifi,
      ConnectivityState.notConnected => Icons.wifi_off,
      ConnectivityState.unknown => Icons.wifi_find,
    };
  }

  Color _getColor(ConnectivityState state) {
    return switch (state) {
      ConnectivityState.connected => Colors.green,
      ConnectivityState.notConnected => Colors.red,
      ConnectivityState.unknown => Colors.grey,
    };
  }
}
