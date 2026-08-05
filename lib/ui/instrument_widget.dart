import 'package:finonex_task/main.dart';
import 'package:finonex_task/models/_models.dart';
import 'package:flutter/material.dart';

class InstrumentWidget extends StatelessWidget {
  const InstrumentWidget({
    super.key,
    required this.instrumentData,
  });

  final InstrumentData instrumentData;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(instrumentData.symbol),
            StreamBuilder(
              stream: modelDeps.tickerModel.getTickerStream(instrumentData.symbol),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildError();
                }

                final TickerData? tickerData = snapshot.data;
                if (tickerData != null) {
                  return _buildData(tickerData);
                }

                return _buildLoading();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Text('---');
  }

  Widget _buildData(TickerData tickerData) {
    return Text(
      '${tickerData.bid.toStringAsFixed(instrumentData.decimals)} / ${tickerData.ask.toStringAsFixed(instrumentData.decimals)}',
      style: const TextStyle(fontFamily: 'monospace'),
    );
  }

  Widget _buildError() {
    return const Text(
      'Error',
      style: TextStyle(
        color: Colors.red,
        fontSize: 10,
      ),
    );
  }
}
