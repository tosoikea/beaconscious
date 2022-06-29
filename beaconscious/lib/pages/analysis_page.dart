import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalysisPage extends BeaconsciousPage {
  const AnalysisPage() : super(key: const ValueKey("AnalysisPage"));

  @override
  Widget get child => Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.analysis_title,
              ),
              actions: [
                IconButton(
                    onPressed: null,
                    icon: Icon(
                        color: Theme.of(context).primaryColor,
                        Icons.info_outlined))
              ],
            ),
            body: Text("lol"));
      });
}
