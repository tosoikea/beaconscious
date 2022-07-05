
import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:beaconscious/widgets/dialogs/detection_device_addition_dialog.dart';
import 'package:beaconscious/widgets/dialogs/detection_device_selection_dialog.dart';
import 'package:beaconscious/widgets/dialogs/detection_type_selection_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetectionAdditionDialog extends StatefulWidget {
  const DetectionAdditionDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetectionAdditionDialogState();
}

enum _DetectionType { none, location, device }

class _DetectionAdditionDialogState extends State<DetectionAdditionDialog> {
  _DetectionType _type = _DetectionType.none;
  Detector? _selected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectionCubit, DetectionState>(
      builder: (context, state) {
        switch (_type) {
          // A) Select Type
          case _DetectionType.none:
            return DetectionTypeSelectionDialog(
                onTap: () => setState(() {
                      _type = _DetectionType.device;
                    }));
          case _DetectionType.device:
            // B) Select Device
            if (_selected == null) {
              return DetectionDeviceSelectionDialog(
                onTap: (e) {
                  setState(() {
                    _selected = e;
                  });
                },
                addable: state.addable,
              );
            }
            // C) Complete Creation
            else {
              return DetectionDeviceAdditionDialog(
                  device: _selected as Device,
                  onSave: (device) async {
                    await BlocProvider.of<DetectionCubit>(context)
                        .addDetector(detector: device);
                  });
            }
          case _DetectionType.location:
            // TODO
            return CustomDialog(
                title: "TODO",
                subtitle: "",
                content: Container(),
                actions: const <Widget>[]);
        }
      },
    );
  }
}
