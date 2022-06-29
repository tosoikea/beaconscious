import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/repositories/environments/models/environment.dart';
import 'package:beaconscious/widgets/detector_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnvironmentDetectorChip extends StatelessWidget {
  final Environment environment;
  final Detector detector;
  late final bool selected;

  EnvironmentDetectorChip(
      {super.key, required this.environment, required this.detector}) {
    selected = (environment.where.any((element) => element == detector.id));
  }

  @override
  Widget build(BuildContext context) => DetectorChip(
        detector: detector,
        selected: selected,
        onTap: () => selected
            ? BlocProvider.of<EnvironmentsCubit>(context).removeDetector(
                environmentId: environment.name, detectorId: detector.id)
            : BlocProvider.of<EnvironmentsCubit>(context).addDetector(
                environmentId: environment.name, detectorId: detector.id),
      );
}
