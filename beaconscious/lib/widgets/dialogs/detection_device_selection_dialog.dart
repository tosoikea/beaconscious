import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/utils/detector_icon_visitor.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:beaconscious/widgets/dialogs/detection_dialog_column_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef DeviceTappedCallback = void Function(Device tapped);

class DetectionDeviceSelectionDialog extends StatelessWidget {
  final List<Device> addable;
  final DeviceTappedCallback onTap;

  const DetectionDeviceSelectionDialog(
      {super.key, required this.onTap, required this.addable});

  @override
  Widget build(BuildContext context) => CustomDialog(
          title: AppLocalizations.of(context)!.detection_selection_title,
          subtitle: AppLocalizations.of(context)!
              .detection_selection_device_selection,
          content: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
                children: addable
                    .map((e) => [
                          DetectionDialogColumnEntry(
                              onTap: () => onTap(e),
                              leading: Icon(
                                  e.accept(DetectorIconVisitor(), context)),
                              children: [Text(e.name)]),
                          const Divider(
                            thickness: 2,
                          )
                        ])
                    .fold<List<Widget>>(
                        <Widget>[],
                        (previousValue, element) => previousValue
                          ..addAll(element)).toList(growable: false)),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel))
          ]);
}
