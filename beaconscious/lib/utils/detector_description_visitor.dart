import 'dart:math';

import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectorDescriptionVisitor extends DetectorVisitor<BuildContext, Widget> {
  @override
  Widget visitDevice(Device device, BuildContext state) => Padding(
        // TODO : ugly padding
        padding: const EdgeInsets.only(left: 8, right: 32),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(state)!.detection_device_bluetooth_name,
                    style: Theme.of(state).textTheme.subtitle2!.copyWith(
                        color: Theme.of(state).colorScheme.onSurfaceVariant),
                  ),
                  Text("TODO")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(state)!
                        .detection_device_bluetooth_strength,
                    style: Theme.of(state).textTheme.subtitle2!.copyWith(
                        color: Theme.of(state).colorScheme.onSurfaceVariant),
                  ),
                  // TODO : Actual value
                  Text("${Random().nextInt(100)} %"),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget visitLocation(Location location, BuildContext state) => Container();
}
