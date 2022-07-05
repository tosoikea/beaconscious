import 'dart:async';

import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:flutter/material.dart';

class LocalEnvironmentsRepository extends EnvironmentsRepository {
  final Map<String, Environment> _environments;
  final StreamController<List<Environment>> _knownController;

  LocalEnvironmentsRepository()
      : _environments = <String, Environment>{},
        _knownController = StreamController<List<Environment>>() {
    _environments["Home Office"] = Environment(
        icon: Icons.business_center,
        name: "Home Office",
        where: const <String>[],
        what: <Rule>[DoNotDisturbRule()],
        when: List.generate(
            7,
            (index) => DayTimeWindow(weekDay: index + 1, ranges: [
                  TimeRange(
                      start: const TimeOfDay(hour: 7, minute: 0),
                      end: const TimeOfDay(hour: 12, minute: 0)),
                  TimeRange(
                      start: const TimeOfDay(hour: 14, minute: 0),
                      end: const TimeOfDay(hour: 16, minute: 0))
                ])));

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
