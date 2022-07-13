import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/custom_date_utils.dart';
import 'package:beaconscious/utils/time_of_day_utils.dart';
import 'package:beaconscious/widgets/addition_widget.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EnvironmentDaytimeWindowDialog extends StatefulWidget {
  final Environment environment;
  final DayTimeWindow window;

  const EnvironmentDaytimeWindowDialog(
      {Key? key, required this.environment, required this.window})
      : super(key: key);

  @override
  State<EnvironmentDaytimeWindowDialog> createState() =>
      _EnvironmentDaytimeWindowDialogState();
}

class _EnvironmentDaytimeWindowDialogState
    extends State<EnvironmentDaytimeWindowDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime _start = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
  DateTime _end = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 13);
  bool _startHasError = false;
  bool _endHasError = false;

  FormFieldValidator<DateTime> min({
    required String name,
  }) =>
      (valueCandidate) => valueCandidate != null &&
              (_formKey.currentState!.value[name] == null ||
                  valueCandidate
                      .isAfter(_formKey.currentState!.value[name] as DateTime))
          ? null
          : "";

  void _verifyUpdate(ValueNotifier<TimeRange?> notifier) {
    if (_formKey.currentState?.validate() ?? false) {
      notifier.value = TimeRange(
          start: TimeOfDay.fromDateTime(
              _formKey.currentState!.value["start"] as DateTime),
          end: TimeOfDay.fromDateTime(
              _formKey.currentState!.value["end"] as DateTime));
    }

    setState(() {
      _startHasError =
          !(_formKey.currentState?.fields['start']?.validate() ?? false);

      _endHasError =
          !(_formKey.currentState?.fields['end']?.validate() ?? false);
    });
  }

  @override
  Widget build(BuildContext context) => CustomDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close))
          ],
          title: AppLocalizations.of(context)!.environment_daytime_window_title(
              CustomDateUtils.getWeekDayNameByNumber(
                  context, widget.window.weekDay)),
          content: Column(
            children: [
              ...widget.window.ranges.map(
                (e) => _EnvironmentTimeRangeWidget(
                  environment: widget.environment,
                  window: widget.window,
                  range: e,
                  readOnly: false,
                ),
              ),
              AdditionWidget<TimeRange>(
                onAdd: (notifier) async {
                  _start = DateTime(1, 1, 1, 12);
                  _end = DateTime(1, 1, 1, 13);
                  notifier.value = TimeRange(
                      start: TimeOfDay.fromDateTime(_start),
                      end: TimeOfDay.fromDateTime(_end));
                },
                onSave: _formKey.currentState != null &&
                        _formKey.currentState!.validate()
                    ? (range) async {
                        await BlocProvider.of<EnvironmentsCubit>(context)
                            .addRange(
                                environmentId: widget.environment.name,
                                weekDay: widget.window.weekDay,
                                range: range);
                      }
                    : null,
                builder: (context, state) {
                  return FormBuilder(
                      autovalidateMode: AutovalidateMode.always,
                      onChanged: () {
                        _formKey.currentState!.save();
                      },
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderDateTimePicker(
                            name: 'start',
                            resetIcon: null,
                            autovalidateMode: AutovalidateMode.always,
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: AppLocalizations.of(context)!
                                  .environment_daytime_window_start,
                              suffixIcon: _startHasError
                                  ? Icon(Icons.error,
                                      color:
                                          Theme.of(context).colorScheme.error)
                                  : const Icon(Icons.check,
                                      color: Colors.green),
                            ),
                            timePickerInitialEntryMode:
                                TimePickerEntryMode.input,
                            inputType: InputType.time,
                            initialValue: DateTime(
                                1,
                                1,
                                1,
                                state.value!.start.hour,
                                state.value!.start.minute),
                            onChanged: (val) {
                              _start = val!;
                              _verifyUpdate(state);
                            },
                          ),
                          FormBuilderDateTimePicker(
                            name: 'end',
                            resetIcon: null,
                            autovalidateMode: AutovalidateMode.always,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              min(name: "start")
                            ]),
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: AppLocalizations.of(context)!
                                  .environment_daytime_window_end,
                              suffixIcon: _endHasError
                                  ? Icon(Icons.error,
                                      color:
                                          Theme.of(context).colorScheme.error)
                                  : const Icon(Icons.check,
                                      color: Colors.green),
                            ),
                            timePickerInitialEntryMode:
                                TimePickerEntryMode.input,
                            inputType: InputType.time,
                            initialValue: DateTime(1, 1, 1,
                                state.value!.end.hour, state.value!.end.minute),
                            onChanged: (val) {
                              _end = val!;
                              _verifyUpdate(state);
                            },
                          )
                        ],
                      ));
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
