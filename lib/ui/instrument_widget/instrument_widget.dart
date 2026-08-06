import 'dart:async';
import 'package:finonex_task/main.dart';
import 'package:finonex_task/ui/instrument_widget/instrument_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstrumentWidget extends StatelessWidget {
  const InstrumentWidget({
    super.key,
    required this.symbol,
  });

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(symbol),
            BlocProvider(
              create: (_) => InstrumentWidgetBloc(
                tickerModel: modelDeps.tickerModel,
                instrumentModel: modelDeps.instrumentModel,
                symbol: symbol,
              )..add(SubRequested()),
              child: BlocBuilder<InstrumentWidgetBloc, InstrumentWidgetState>(
                builder: (context, state) {
                  return switch (state) {
                    NoData() => _buildNoData(),
                    FailedToGetInstrumentData() => _buildError(),
                    DataLoaded() => _buildData(state),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return const Text('---');
  }

  Widget _buildData(DataLoaded state) {
    const TextStyle style = TextStyle(fontFamily: 'monospace');

    return Column(
      children: [
        _PriceFlash(
          value: state.bid,
          child: Text(
            'B: ${state.bid.toStringAsFixed(state.decimals)}',
            style: style,
          ),
        ),
        _PriceFlash(
          value: state.ask,
          child: Text(
            'A: ${state.ask.toStringAsFixed(state.decimals)}',
            style: style,
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return const Text(
      'Err',
      style: TextStyle(
        color: Colors.red,
        fontSize: 10,
      ),
    );
  }
}

class _PriceFlash extends StatefulWidget {
  const _PriceFlash({
    required this.value,
    required this.child,
  });

  final double value;
  final Widget child;

  @override
  State<_PriceFlash> createState() => _PriceFlashState();
}

class _PriceFlashState extends State<_PriceFlash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.transparent,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(_PriceFlash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final Color flashColor;
      if (widget.value > oldWidget.value) {
        flashColor = Colors.green.withValues(alpha: 0.5);
      } else {
        flashColor = Colors.red.withValues(alpha: 0.5);
      }

      _colorAnimation = ColorTween(
        begin: flashColor,
        end: Colors.transparent,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      unawaited(_controller.forward(from: 0.0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: _colorAnimation.value,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
