import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/widgets/cards/custom_card.dart';
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
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.environments_title,
              ),
              actions: [
                IconButton(
                    onPressed: null,
                    icon: Icon(
                        color: Theme.of(context).primaryColor,
                        Icons.info_outlined))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
                builder: (context, state) => SingleChildScrollView(
                  child: Column(
                    children: state.environments.map((e) {
                      bool isCurrent = state.current.name == e.name;

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: CustomCard(
                          leading: e.icon, title: e.name,
                          //TODO : Determine the actual day (e.g. gestern, etc.)
                          subtitle: (isCurrent)
                              ? AppLocalizations.of(context)!
                                  .environments_currently_active
                              : AppLocalizations.of(context)!
                                  .environments_previously_active("heute"),
                          subtitleColor: (isCurrent)
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          action: const IconButton(
                            onPressed: null,
                            icon: Icon(size: 24, Icons.arrow_drop_down_rounded),
                          ),
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ),
            ));
      });
}
