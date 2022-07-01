import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/constants.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/utils/detector_description_visitor.dart';
import 'package:beaconscious/utils/detector_icon_visitor.dart';
import 'package:beaconscious/widgets/cards/custom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DetectorWidget extends StatefulWidget {
  final Detector detector;
  final bool active;

  const DetectorWidget(
      {super.key, required this.detector, required this.active});

  @override
  State<StatefulWidget> createState() => _DetectorWidgetState();
}

class _DetectorWidgetState extends State<DetectorWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return CustomCard(
        leading: widget.detector.accept(DetectorIconVisitor(), context),
        title: widget.detector.name,
        subtitle: (widget.active)
            ? AppLocalizations.of(context)!.detection_currently_detected
            : AppLocalizations.of(context)!.detection_currently_not_detected,
        subtitleColor: (widget.active)
            ? Constants.primary50
            : Theme.of(context).colorScheme.tertiary,
        action: IconButton(
          onPressed: () => setState(() {
            expanded = true;
          }),
          icon: Icon(size: 24, Icons.arrow_drop_down_rounded),
        ),
      );
    } else {
      return CustomCard(
        backgroundColor: Constants.primary80,
        leading: widget.detector.accept(DetectorIconVisitor(), context),
        title: widget.detector.name,
        subtitle: (widget.active)
            ? AppLocalizations.of(context)!.detection_currently_detected
            : AppLocalizations.of(context)!.detection_currently_not_detected,
        subtitleColor: (widget.active)
            ? Constants.primary50
            : Theme.of(context).colorScheme.tertiary,
        content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                widget.detector.accept(DetectorDescriptionVisitor(), context)),
        caption: Row(
          children: [
            const Spacer(),
            MaterialButton(
                onPressed: () async =>
                    await BlocProvider.of<DetectionCubit>(context)
                        .removeDetector(detector: widget.detector),
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    Text(AppLocalizations.of(context)!.delete)
                  ],
                ))
          ],
        ),
        action: IconButton(
          onPressed: () => setState(() {
            expanded = false;
          }),
          icon: Icon(size: 24, Icons.arrow_drop_up_rounded),
        ),
      );
    }
  }
}
