import 'package:finonex_task/main.dart';
import 'package:finonex_task/models/ticker/_ticker.dart';
import 'package:finonex_task/ui/connectivity_indicator/connectivity_indicator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConnectivityIndicatorBloc(
        tickerModel: modelDeps.tickerModel,
      )..add(SubRequested()),
      child: BlocBuilder<ConnectivityIndicatorBloc, TickerConnectionState>(
        builder: (context, state) {
          return Text(
            state.name,
          );
        },
      ),
    );
  }
}
