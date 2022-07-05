import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/widgets/detection_screen_widget.dart';
import 'package:beaconscious/widgets/dialogs/detection_addition_dialog.dart';
import 'package:beaconscious/widgets/dialogs/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectionPage extends BeaconsciousPage {
  const DetectionPage() : super(key: const ValueKey("DetectionPage"));

  @override
  Widget get child => Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await BlocProvider.of<DetectionCubit>(context).load();
                await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const DetectionAdditionDialog());
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.detection_title,
              ),
              actions: [
                IconButton(
                    onPressed: () async => await showDialog(
                        context: context,
                        builder: (BuildContext context) => InfoDialog(
                            title:
                                AppLocalizations.of(context)!.detection_title,
                            description:
                                AppLocalizations.of(context)!.info_detection)),
                    icon: Icon(
                        color: Theme.of(context).primaryColor,
                        Icons.info_outlined))
              ],
            ),
            body: const Padding(
              padding: EdgeInsets.all(8.0),
              child: DetectionScreenWidget(),
            ));
      });
}
