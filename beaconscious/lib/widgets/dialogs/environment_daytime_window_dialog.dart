import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/custom_date_utils.dart';
import 'package:beaconscious/utils/time_of_day_utils.dart';
import 'package:beaconscious/widgets/addition_widget.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:time_range_picker/time_range_picker.dart' as picker;

class EnvironmentDaytimeWindowDialog extends StatelessWidget {
  final Environment environment;
  final DayTimeWindow window;

  const EnvironmentDaytimeWindowDialog(
      {Key? key, required this.environment, required this.window})
      : super(key: key);

  @override
  Widget build(BuildContext context) => CustomDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close))
          ],
          title: AppLocalizations.of(context)!.environment_daytime_window_title(
              CustomDateUtils.getWeekDayNameByNumber(context, window.weekDay)),
          content: Column(
            children: [
              ...window.ranges.map(
                (e) => _EnvironmentTimeRangeWidget(
                  environment: environment,
                  window: window,
                  range: e,
                  readOnly: false,
                ),
              ),
              AdditionWidget<TimeRange>(
                onSave: (range) async {
                  await BlocProvider.of<EnvironmentsCubit>(context).addRange(
                      environmentId: environment.name,
                      weekDay: window.weekDay,
                      range: range);
                },
                builder: (context, state) {
                  if (state.value == null) {
                    return Container();
                  }

                  return _EnvironmentTimeRangeWidget(
                    environment: environment,
                    window: window,
                    range: state.value!,
                    readOnly: true,
                  );
                },
                onAdd: (notifier) async {
                  final result =
                      await picker.showTimeRangePicker(context: context);

                  if (result != null) {
                    final range = result as picker.TimeRange;
                    notifier.value =
                        TimeRange(start: range.startTime, end: range.endTime);
                  }
                },
              )
            ],
          ));
}

class _EnvironmentTimeRangeWidget extends StatelessWidget {
  final Environment environment;
  final DayTimeWindow window;
  final TimeRange range;
  final bool readOnly;

  const _EnvironmentTimeRangeWidget(
      {Key? key,
      required this.environment,
      required this.window,
      required this.range,
      required this.readOnly})
      : super(key: key);

  Widget _getChild(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${TimeOfDayUtils.getPadded(range.start)} - ${TimeOfDayUtils.getPadded(range.end)}",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ]);

  @override
  Widget build(BuildContext context) => (!readOnly)
      ? Dismissible(
          key: ValueKey(range),
          direction: DismissDirection.startToEnd,
          background: Container(color: Theme.of(context).colorScheme.tertiary),
          onDismissed: (DismissDirection direction) async {
            await BlocProvider.of<EnvironmentsCubit>(context).removeRange(
                environmentId: environment.name,
                weekDay: window.weekDay,
                range: range);
          },
          child: _getChild(context))
      : _getChild(context);
}
