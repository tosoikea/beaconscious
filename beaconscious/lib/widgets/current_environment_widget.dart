import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:flutter/cupertino.dart';
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
                leading: state.current.icon,
                title: AppLocalizations.of(context)!.environment_card_title,
                subtitle: state.current.name,
                onTap: () =>
                    BlocProvider.of<NavigationCubit>(context).toEnvironments(),
              ));
}
