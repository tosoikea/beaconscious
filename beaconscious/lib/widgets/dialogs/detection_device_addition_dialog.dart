import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

typedef DeviceSavedCallback = Future<void> Function(Device saved);

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
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = true;

  @override
  Widget build(BuildContext context) => CustomDialog(
        title: AppLocalizations.of(context)!
            .detection_selection_device_creation_title,
        subtitle:
            AppLocalizations.of(context)!.detection_selection_device_creation,
        content: FormBuilder(
          key: _formKey,
          onChanged: () {
            _formKey.currentState!.save();
          },
          child: Column(
            children: [
              FormBuilderTextField(
                autovalidateMode: AutovalidateMode.always,
                name: 'name',
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context)!.detection_device_name,
                  suffixIcon: _nameHasError
                      ? Icon(Icons.error,
                          color: Theme.of(context).colorScheme.error)
                      : const Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (val) {
                  setState(() {
                    _nameHasError =
                        !(_formKey.currentState?.fields['name']?.validate() ??
                            false);
                  });
                },
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
              onPressed: _formKey.currentState != null &&
                      _formKey.currentState!.validate()
                  ? () async {
                      await widget
                          .onSave(widget.device.copyWith(
                              name: _formKey.currentState!.value["name"]))
                          .whenComplete(() {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!.ok)),
        ],
      );
}
