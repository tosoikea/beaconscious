import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef DeviceSavedCallback = void Function(Device saved);

class DetectionDeviceAdditionDialog extends StatefulWidget {
  final Device device;
  final DeviceSavedCallback onSave;

  const DetectionDeviceAdditionDialog(
      {super.key, required this.device, required this.onSave});

  @override
  State<DetectionDeviceAdditionDialog> createState() =>
      _DetectionDeviceAdditionDialogState();
}

class _DetectionDeviceAdditionDialogState
    extends State<DetectionDeviceAdditionDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomDialog(
        title: AppLocalizations.of(context)!
            .detection_selection_device_creation_title,
        subtitle:
            AppLocalizations.of(context)!.detection_selection_device_creation,
        content: TextFormField(
          controller: _nameController,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                widget
                    .onSave(widget.device.copyWith(name: _nameController.text));
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.ok)),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel))
        ],
      );
}
