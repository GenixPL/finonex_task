import 'package:finonex_task/main.dart';
import 'package:finonex_task/ui/instrument_container/instrument_container_bloc.dart';
import 'package:finonex_task/ui/instrument_widget/instrument_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstrumentsContainer extends StatelessWidget {
  const InstrumentsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InstrumentContainerBloc(
        instrumentModel: modelDeps.instrumentModel,
      )..add(Init()),
      child: BlocBuilder<InstrumentContainerBloc, InstrumentContainerState>(
        builder: (context, state) {
          return switch (state) {
            Loading() => _buildLoading(),
            FailedToLoad() => _buildError(),
            Loaded() => _buildData(state),
          };
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text('Failed to load instruments'),
    );
  }

  Widget _buildData(Loaded state) {
    return ListView.builder(
      itemCount: state.instruments.length,
      itemBuilder: (context, index) {
        final instrument = state.instruments[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InstrumentWidget(
            symbol: instrument.symbol,
          ),
        );
      },
    );
  }
}
