import 'dart:async';

import 'package:beaconscious/constants.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/repositories/environments/models/rules/restricted_app_usage_rule.dart';
import 'package:flutter/material.dart';

class LocalEnvironmentsRepository extends EnvironmentsRepository {
  final Map<String, Environment> _environments;
  final StreamController<List<Environment>> _knownController;

  LocalEnvironmentsRepository()
      : _environments = <String, Environment>{},
        _knownController = StreamController<List<Environment>>() {
    /// DUMMY VALUES FOR PROTOTYPING
    _environments["Freizeit"] = Environment(
        disabled: false,
        icon: Icons.chair,
        name: "Freizeit",
        where: const <String>[
          /// BEA0001 ID in Firebease, automatisch generiert
          "caOzLnr49dQR5eOjKKHB"
        ],
        what: const <Rule>[
          RestrictedAppUsageRule(
              applications: [Constants.instagram, Constants.outlook]),
          DisabledAppNotificationsRule(applications: [Constants.outlook])
        ],
        when: [
          DayTimeWindow(weekDay: 1, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 12, minute: 00),
                end: const TimeOfDay(hour: 13, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 18, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ]),
          DayTimeWindow(weekDay: 2, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 12, minute: 00),
                end: const TimeOfDay(hour: 13, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 18, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ]),
          DayTimeWindow(weekDay: 3, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 12, minute: 00),
                end: const TimeOfDay(hour: 13, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 18, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ]),
          DayTimeWindow(weekDay: 4, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 12, minute: 00),
                end: const TimeOfDay(hour: 13, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 18, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ]),
          DayTimeWindow(weekDay: 5, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 12, minute: 00),
                end: const TimeOfDay(hour: 13, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 18, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ]),
          DayTimeWindow(weekDay: 6, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 8, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ]),
          DayTimeWindow(weekDay: 7, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 8, minute: 00),
                end: const TimeOfDay(hour: 20, minute: 00)),
          ])
        ]);

    _environments["Schlafen"] = Environment(
        disabled: false,
        icon: Icons.bedtime,
        name: "Schlafen",
        where: const <String>[
          /// BEA0001 ID in Firebease, automatisch generiert
          "89wJ7ijdDS1zUaBAMfMu"
        ],
        what: const <Rule>[
          DoNotDisturbRule(),
          DisabledAppNotificationsRule(applications: [
            Constants.outlook,
            Constants.instagram,
            Constants.tiktok,
            Constants.whatsapp
          ])
        ],
        when: [
          DayTimeWindow(weekDay: 1, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 5, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 20, minute: 30),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ]),
          DayTimeWindow(weekDay: 2, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 5, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 20, minute: 30),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ]),
          DayTimeWindow(weekDay: 3, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 5, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 20, minute: 30),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ]),
          DayTimeWindow(weekDay: 4, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 5, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 20, minute: 30),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ]),
          DayTimeWindow(weekDay: 5, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 5, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 20, minute: 30),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ]),
          DayTimeWindow(weekDay: 6, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 7, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 22, minute: 00),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ]),
          DayTimeWindow(weekDay: 7, ranges: [
            TimeRange(
                start: const TimeOfDay(hour: 0, minute: 00),
                end: const TimeOfDay(hour: 8, minute: 00)),
            TimeRange(
                start: const TimeOfDay(hour: 20, minute: 30),
                end: const TimeOfDay(hour: 23, minute: 59)),
          ])
        ]);

    _updateEnvironments();
  }

  /// Appends the currently known environments to the stream.
  void _updateEnvironments() =>
      _knownController.add(_environments.values.toList(growable: false));

  @override
  Future<bool> addEnvironment({required Environment environment}) {
    if (_environments.containsKey(environment.name)) {
      return Future.value(false);
    }

    _environments[environment.name] = environment;
    _updateEnvironments();
    return Future.value(true);
  }

  @override
  Future<bool> removeEnvironment({required String environmentId}) {
    if (!_environments.containsKey(environmentId)) {
      return Future.value(false);
    }

    _environments.remove(environmentId);
    _updateEnvironments();
    return Future.value(true);
  }

  @override
  Future<bool> updateEnvironment(
      {required String environmentId, required Environment environment}) {
    if (!_environments.containsKey(environment.name)) {
      return Future.value(false);
    }

    _environments[environment.name] = environment;
    _updateEnvironments();
    return Future.value(true);
  }

  @override
  Stream<List<Environment>> streamEnvironments() => _knownController.stream;

  void dispose() {
    _knownController.close();
  }
}
