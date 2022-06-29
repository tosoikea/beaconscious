import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:beaconscious/widgets/cards/card_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cards/custom_card.dart';

class CurrentAnalysisWidget extends StatelessWidget {
  final int hours = 1;
  final int minutes = 20;

  const CurrentAnalysisWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
          builder: (context, state) => CustomCard(
                leading: Icons.bar_chart,
                title: AppLocalizations.of(context)!.analysis_card_title,
                caption: CardTitle(
                    title: AppLocalizations.of(context)!
                        .analysis_card_caption_title,
                    subtitle:
                        "${(hours == 1) ? AppLocalizations.of(context)!.analysis_card_caption_hour : AppLocalizations.of(context)!.analysis_card_caption_hours(hours)} ${AppLocalizations.of(context)!.and} ${(minutes == 1) ? AppLocalizations.of(context)!.analysis_card_caption_minute : AppLocalizations.of(context)!.analysis_card_caption_minutes(minutes)} ${AppLocalizations.of(context)!.analysis_card_caption_environment(state.current.name)}"),
                onTap: () =>
                    BlocProvider.of<NavigationCubit>(context).toAnalysis(),
              ));
}
