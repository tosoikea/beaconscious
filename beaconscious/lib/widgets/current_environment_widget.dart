import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cards/custom_card.dart';

class CurrentEnvironmentWidget extends StatelessWidget {
  const CurrentEnvironmentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
          builder: (context, state) => CustomCard(
              leading: (state.current.isEmpty)
                  ? Icons.warning_rounded
                  : state.current.icon,
              leadingBackgroundColor: (state.current.isEmpty)
                  ? Theme.of(context).colorScheme.error
                  : null,
              title: AppLocalizations.of(context)!.environment_card_title,
              subtitle: AppLocalizations.of(context)!.environment_card_detected(
                  (state.current.isEmpty)
                      ? AppLocalizations.of(context)!.environment_card_unknown
                      : state.current.name),
              onTap: () =>
                  BlocProvider.of<NavigationCubit>(context).toEnvironments()));
}
