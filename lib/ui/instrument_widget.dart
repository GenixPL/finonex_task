import 'package:finonex_task/models/_models.dart';
import 'package:flutter/material.dart';

class InstrumentWidget extends StatelessWidget {
  const InstrumentWidget({
    super.key,
    required this.data,
  });

  final InstrumentData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(data.symbol),
      ),
    );
  }
}
