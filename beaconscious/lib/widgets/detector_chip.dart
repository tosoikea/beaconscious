import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/utils/detector_icon_visitor.dart';
import 'package:beaconscious/widgets/custom_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetectorChip extends StatelessWidget {
  final Detector detector;
  final bool selected;
  final VoidCallback? onTap;

  const DetectorChip(
      {super.key, this.onTap, required this.detector, required this.selected});

  @override
  Widget build(BuildContext context) => CustomChip(
      avatar: Icon(
        detector.accept(DetectorIconVisitor(), context),
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        detector.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      selected: selected,
      onTap: onTap);
}
