import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/widgets/dialogs/info_dialog.dart';
import 'package:beaconscious/widgets/environment/environment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnvironmentPage extends BeaconsciousPage {
  const EnvironmentPage() : super(key: const ValueKey("EnvironmentPage"));

  @override
  Widget get child => Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print("Pressed");
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.environments_title,
              ),
              actions: [
                IconButton(
                    onPressed: () async => await showDialog(
                        context: context,
                        builder: (BuildContext context) => InfoDialog(
                            title: AppLocalizations.of(context)!
                                .environments_title,
                            description: AppLocalizations.of(context)!
                                .info_environment)),
                    icon: Icon(
                        color: Theme.of(context).primaryColor,
                        Icons.info_outlined))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
                builder: (context, state) => SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ...state.environments.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: EnvironmentWidget(
                            environment: e,
                          ),
                        )),
                    // Allow for "overscroll"
                    const SizedBox(
                      height: 64,
                    )
                  ]),
                ),
              ),
            ));
      });
}
