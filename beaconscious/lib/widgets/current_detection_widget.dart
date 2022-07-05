import 'package:beaconscious/blocs/detection/detection_cubit.dart';
import 'package:beaconscious/blocs/detection/detection_state.dart';
import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:beaconscious/repositories/detection/models/device.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/widgets/cards/card_title.dart';
import 'package:beaconscious/widgets/current_detection_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cards/custom_card.dart';

class CurrentDetectionWidget extends StatelessWidget {
  const CurrentDetectionWidget({Key? key}) : super(key: key);

  int _amountOfDevices(DetectionState state) =>
      state.detected.whereType<Device>().length;
  int _amountOfLocations(DetectionState state) =>
      state.detected.whereType<Location>().length;

  String _deviceDescription(BuildContext context, int devices) {
    if (devices == 0) {
      return AppLocalizations.of(context)!.detection_close_device_zero;
    } else if (devices == 1) {
      return AppLocalizations.of(context)!.detection_close_device_singular;
    } else {
      return AppLocalizations.of(context)!
          .detection_close_device_plural(devices);
    }
  }

  String _locationDescription(BuildContext context, int locations) {
    if (locations == 0) {
      return AppLocalizations.of(context)!.detection_close_location_zero;
    } else if (locations == 1) {
      return AppLocalizations.of(context)!.detection_close_location_singular;
    } else {
      return AppLocalizations.of(context)!
          .detection_close_location_plural(locations);
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetectionCubit, DetectionState>(builder: (context, state) {
        int devices = _amountOfDevices(state);
        int locations = _amountOfLocations(state);

        return CustomCard(
            leading: Icons.bluetooth,
            title: AppLocalizations.of(context)!.detection_card_title,
            content: Container(
                height: 160,
                color: Theme.of(context).colorScheme.onPrimary,
                child: const CurrentDetectionViewWidget()),
            caption: CardTitle(
              title: AppLocalizations.of(context)!.detection_card_caption_title,
              subtitle:
                  "${_deviceDescription(context, devices)} ${AppLocalizations.of(context)!.and} ${_locationDescription(context, locations)}",
            ),
            onTap: () =>
                BlocProvider.of<NavigationCubit>(context).toDetection());
      });
}
