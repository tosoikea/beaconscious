import 'package:beaconscious/blocs/analysis/analysis.dart';
import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:beaconscious/widgets/cards/card_title.dart';
import 'package:beaconscious/widgets/current_analysis_week_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cards/custom_card.dart';

class CurrentAnalysisWidget extends StatelessWidget {
  const CurrentAnalysisWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
          builder: (context, state) =>
              BlocBuilder<AnalysisCubit, AnalysisState>(
                  builder: (context, aState) {
                final seconds =
                    aState.currentDay.containsKey(state.current.name)
                        ? aState.currentDay[state.current.name]!.seconds
                        : 0;

                int hours = seconds ~/ 3600;
                int minutes = (seconds - (hours * 3600)) ~/ 60;

                return CustomCard(
                  leading: Icons.bar_chart,
                  leadingBackgroundColor: (state.current.isEmpty)
                      ? Theme.of(context).colorScheme.tertiary
                      : null,
                  title: AppLocalizations.of(context)!.analysis_card_title,
                  subtitle: (state.current.isEmpty)
                      ? AppLocalizations.of(context)!.analysis_card_unknown
                      : null,
                  content: (state.current.isEmpty)
                      ? null
                      : Container(
                          width: double.infinity,
                          height: 160,
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: CurrentAnalysisWeekWidget(
                              environment: state.current)),
                  caption: (state.current.isEmpty)
                      ? null
                      : CardTitle(
                          title: AppLocalizations.of(context)!
                              .analysis_card_caption_title,
                          subtitle:
                              "${(hours == 1) ? AppLocalizations.of(context)!.analysis_card_caption_hour : AppLocalizations.of(context)!.analysis_card_caption_hours(hours)} ${AppLocalizations.of(context)!.and} ${(minutes == 1) ? AppLocalizations.of(context)!.analysis_card_caption_minute : AppLocalizations.of(context)!.analysis_card_caption_minutes(minutes)} ${AppLocalizations.of(context)!.analysis_card_caption_environment(state.current.name)}"),
                  onTap: () =>
                      BlocProvider.of<NavigationCubit>(context).toAnalysis(),
                );
              }));
}
