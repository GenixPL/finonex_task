import 'package:finonex_task/main.dart';
import 'package:finonex_task/models/_models.dart';
import 'package:finonex_task/ui/instrument_widget.dart';
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
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final instruments = _instruments;
    if (instruments == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // TODO(genix): calc
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: instruments.length,
      itemBuilder: (context, index) {
        final instrument = instruments[index];

        return RepaintBoundary(
          child: InstrumentWidget(data: instrument),
        );
      },
    );
  }
}
