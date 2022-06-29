import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/widgets/detection_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectionPage extends BeaconsciousPage {
  const DetectionPage() : super(key: const ValueKey("DetectionPage"));

  @override
  Widget get child => Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.detection_title,
              ),
              actions: [
                IconButton(
                    onPressed: null,
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
