import 'package:finonex_task/main.dart';
import 'package:finonex_task/models/_models.dart';
import 'package:flutter/material.dart';

class InstrumentsContainer extends StatefulWidget {
  const InstrumentsContainer({super.key});

  @override
  State<InstrumentsContainer> createState() => _InstrumentsContainerState();
}

class _InstrumentsContainerState extends State<InstrumentsContainer> {
  List<InstrumentData>? _instruments;

  @override
  void initState() {
    super.initState();
    modelDeps.instrumentModel.getInstruments().then((value) {
      _instruments = value;
      if (mounted) {}
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_instruments == null) {
      return CircularProgressIndicator();
    }

    return GridView.builder(

    );
  }
}
