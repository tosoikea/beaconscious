import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/custom_date_utils.dart';
import 'package:beaconscious/widgets/dialogs/environment_daytime_window_dialog.dart';
import 'package:beaconscious/widgets/time_ranges_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnvironmentWhenWidget extends StatelessWidget {
  final Environment environment;

  const EnvironmentWhenWidget({super.key, required this.environment});

  @override
  Widget build(BuildContext context) => Column(
        children: environment.when
            .map((e) => Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Center(
                          child: Text(
                            CustomDateUtils.getWeekDayShortNameByNumber(
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
                        padding: const EdgeInsets.only(left: 16.0),
                        child: GestureDetector(
                            child: TimeRangesWidget(ranges: e.ranges),
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      BlocBuilder<EnvironmentsCubit,
                                          EnvironmentsState>(
                                        builder: (context, state) {
                                          final current = state.environments
                                              .firstWhere((element) =>
                                                  element.name ==
                                                  environment.name);
                                          return EnvironmentDaytimeWindowDialog(
                                              environment: current,
                                              window: current.when.firstWhere(
                                                  (element) =>
                                                      element.weekDay ==
                                                      e.weekDay));
                                        },
                                      ));
                            }),
                      )),
                    ],
                  ),
                ))
            .toList(),
      );
}
