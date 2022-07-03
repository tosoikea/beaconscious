import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/custom_date_utils.dart';
import 'package:beaconscious/widgets/dialogs/environments_deletion_dialog.dart';
import 'package:beaconscious/widgets/environment_detector_chip.dart';
import 'package:beaconscious/widgets/rule_widget.dart';
import 'package:beaconscious/widgets/time_ranges_widget.dart';
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
                  const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.environments_where,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 8, right: 8),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: dState.detectors
                          .map((e) => EnvironmentDetectorChip(
                              environment: environment, detector: e))
                          .toList(growable: false),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(AppLocalizations.of(context)!.environments_when,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: environment.when
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      child: Center(
                                        child: Text(
                                          CustomDateUtils
                                              .getWeekDayShortNameByNumber(
                                                  context, e.weekDay),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: TimeRangesWidget(ranges: e.ranges),
                                    )),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  // TODO
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(AppLocalizations.of(context)!.environments_what,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                  ),
                  Column(
                    children: environment.what
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: RuleWidget(
                                environment: environment,
                                rule: e,
                              ),
                            ))
                        .toList(growable: false),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      MaterialButton(
                          onPressed: () async => await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  EnvironmentsDeletionDialog(
                                      environment: environment)),
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              Text(AppLocalizations.of(context)!.delete)
                            ],
                          ))
                    ],
                  )
                ],
              ),
            ));
      });
}
