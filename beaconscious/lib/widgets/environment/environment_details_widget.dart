import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/widgets/dialogs/environments_deletion_dialog.dart';
import 'package:beaconscious/widgets/environment/environment_details_section_widget.dart';
import 'package:beaconscious/widgets/environment/environment_rule_addition_widget.dart';
import 'package:beaconscious/widgets/environment/environment_when_widget.dart';
import 'package:beaconscious/widgets/environment/environment_detector_chip.dart';
import 'package:beaconscious/widgets/rule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnvironmentDetailsWidget extends StatelessWidget {
  final Environment environment;

  const EnvironmentDetailsWidget({Key? key, required this.environment})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetectionCubit, DetectionState>(builder: (context, dState) {
        return Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EnvironmentDetailsSectionWidget(
                    title: AppLocalizations.of(context)!.environments_where,
                    builder: (context) => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: dState.detectors
                          .map((e) => EnvironmentDetectorChip(
                              environment: environment, detector: e))
                          .toList(growable: false),
                    ),
                  ),
                  EnvironmentDetailsSectionWidget(
                      title: AppLocalizations.of(context)!.environments_when,
                      builder: (context) =>
                          EnvironmentWhenWidget(environment: environment)),
                  EnvironmentDetailsSectionWidget(
                      title: AppLocalizations.of(context)!.environments_what,
                      builder: (context) => Column(
                            children: [
                              ...environment.what.map<Widget>((e) => Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: RuleWidget(
                                      environment: environment,
                                      rule: e,
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: EnvironmentRuleAdditionWidget(
                                      environment: environment))
                            ],
                          )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                            style: TextButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.tertiary),
                            onPressed: () async => await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    EnvironmentsDeletionDialog(
                                        environment: environment)),
                            icon: const Icon(Icons.delete),
                            label: Text(AppLocalizations.of(context)!.delete)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: (!environment.disabled)
                              ? TextButton.icon(
                                  onPressed: () async =>
                                      await BlocProvider.of<EnvironmentsCubit>(
                                              context)
                                          .disableEnvironment(
                                              environment: environment),
                                  icon: const Icon(Icons.stop),
                                  label: Text(
                                      AppLocalizations.of(context)!.disable))
                              : TextButton.icon(
                                  onPressed: () async =>
                                      await BlocProvider.of<EnvironmentsCubit>(
                                              context)
                                          .enableEnvironment(
                                              environment: environment),
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: Text(AppLocalizations.of(context)!.enable)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      });
}
