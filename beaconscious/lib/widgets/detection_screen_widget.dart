import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/widgets/detector_chip.dart';
import 'package:beaconscious/widgets/detector_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectionScreenWidget extends StatefulWidget {
  const DetectionScreenWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetectionScreenWidget();
}

class _DetectionScreenWidget extends State<DetectionScreenWidget> {
  bool devicesActive = true;
  bool locationsActive = true;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetectionCubit, DetectionState>(
        builder: (context, state) => SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  DetectorChip(
                    detector: Device.empty.copyWith(
                        name: AppLocalizations.of(context)!.detection_device),
                    selected: devicesActive,
                    onTap: () => setState(() {
                      devicesActive = !devicesActive;
                    }),
                  ),
                  DetectorChip(
                    detector: Location.empty.copyWith(
                        name: AppLocalizations.of(context)!.detection_location),
                    selected: locationsActive,
                    onTap: () => setState(() {
                      locationsActive = !locationsActive;
                    }),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: state.detectors
                        .where((element) =>
                            (devicesActive && element is Device) ||
                            (locationsActive && element is Location))
                        .map((e) {
                      bool isCurrent =
                          state.detected.any((element) => element.id == e.id);

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: DetectorWidget(
                          active: isCurrent,
                          detector: e,
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
