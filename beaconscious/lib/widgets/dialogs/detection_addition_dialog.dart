import 'dart:math';

import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/utils/detector_icon_visitor.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectionAdditionDialog extends StatefulWidget {
  const DetectionAdditionDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetectionAdditionDialogState();
}

enum _DetectionType { none, location, device }

class _DialogColumnEntry extends StatelessWidget {
  VoidCallback onTap;
  Widget leading;
  List<Widget> children;

  _DialogColumnEntry(
      {required this.onTap, required this.leading, required this.children});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(child: leading),
            ),
            ...children.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: e,
                ))
          ],
        ),
      );
}

class _DetectionAdditionDialogState extends State<DetectionAdditionDialog> {
  TextEditingController? _nameController;
  _DetectionType _type = _DetectionType.none;
  Detector? _selected;

  @override
  void dispose() {
    if (_nameController != null) {
      _nameController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectionCubit, DetectionState>(
      builder: (context, state) {
        switch (_type) {
          // A) Select Type
          case _DetectionType.none:
            return CustomDialog(
                title: AppLocalizations.of(context)!.detection_selection_title,
                subtitle:
                    AppLocalizations.of(context)!.detection_selection_type,
                content: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      _DialogColumnEntry(
                        onTap: () => setState(() {
                          _type = _DetectionType.device;
                        }),
                        leading: Icon(Icons.devices_other_rounded),
                        children: [
                          Text(AppLocalizations.of(context)!.detection_device)
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      _DialogColumnEntry(
                        onTap: () => setState(() {
                          _type = _DetectionType.location;
                        }),
                        leading: Icon(Icons.location_on),
                        children: [
                          Text(AppLocalizations.of(context)!.detection_location)
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.cancel))
                ]);
          case _DetectionType.device:
            // B) Select Device
            if (_selected == null) {
              return CustomDialog(
                  title:
                      AppLocalizations.of(context)!.detection_selection_title,
                  subtitle: AppLocalizations.of(context)!
                      .detection_selection_device_selection,
                  content: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                        children: state.addable
                            .map((e) => [
                                  _DialogColumnEntry(
                                      onTap: () {
                                        setState(() {
                                          _selected = e;

                                          _nameController =
                                              TextEditingController(
                                                  text: e.name);
                                        });
                                      },
                                      leading: Icon(e.accept(
                                          DetectorIconVisitor(), context)),
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
            // C) Complete Creation
            else {
              return CustomDialog(
                title: AppLocalizations.of(context)!
                    .detection_selection_device_creation_title,
                subtitle: AppLocalizations.of(context)!
                    .detection_selection_device_creation,
                content: TextFormField(
                  controller: _nameController!,
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => print(_nameController!.text),
                      child: Text(AppLocalizations.of(context)!.ok)),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.cancel))
                ],
              );
            }
          case _DetectionType.location:
            // TODO
            return CustomDialog(
                title: "TODO",
                subtitle: "",
                content: Container(),
                actions: <Widget>[]);
        }
      },
    );
  }
}
