import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog_column.dart';
import 'package:beaconscious/widgets/dialogs/detection_dialog_column_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectionTypeSelectionDialog extends StatelessWidget {
  final VoidCallback onTap;

  const DetectionTypeSelectionDialog({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => CustomDialog(
          title: AppLocalizations.of(context)!.detection_selection_title,
          subtitle: AppLocalizations.of(context)!.detection_selection_type,
          content: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CustomDialogColumn(
                children: [
                  DetectionDialogColumnEntry(
                    onTap: onTap,
                    leading: const Icon(Icons.devices_other_rounded),
                    children: [
                      Text(AppLocalizations.of(context)!.detection_device)
                    ],
                  ),
                  DetectionDialogColumnEntry(
                    onTap: onTap,
                    leading: const Icon(Icons.location_on),
                    children: [
                      Text(AppLocalizations.of(context)!.detection_location)
                    ],
                  ),
                ],
              )),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel))
          ]);
}
