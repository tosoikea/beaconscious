import 'dart:async';

import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:flutter/material.dart';

class DummyEnvironmentsRepository extends EnvironmentsRepository {
  final StreamController<Environment> _detectedController;
  final StreamController<List<Environment>> _knownController;
  final Map<String, Environment> _environments;

  DummyEnvironmentsRepository()
      : _environments = <String, Environment>{},
        _detectedController = StreamController<Environment>(),
        _knownController = StreamController<List<Environment>>() {
    _environments["Home Office"] = Environment(
        icon: Icons.business_center,
        name: "Home Office",
        where: const <String>[
          "device-001",
          "location-001"
        ],
        what: <Rule>[
          DoNotDisturbRule()
        ],
        when: const <TimeRange>[
          TimeRange(
              start: TimeOfDay(hour: 7, minute: 0),
              end: TimeOfDay(hour: 12, minute: 0)),
          TimeRange(
              start: TimeOfDay(hour: 14, minute: 0),
              end: TimeOfDay(hour: 16, minute: 0))
        ]);

    _environments["Schlafen"] = Environment(
        icon: Icons.bedtime,
        name: "Schlafen",
        where: const <String>[
          "device-002",
          "location-001"
        ],
        what: <Rule>[
          DoNotDisturbRule()
        ],
        when: const <TimeRange>[
          TimeRange(
              start: TimeOfDay(hour: 0, minute: 0),
              end: TimeOfDay(hour: 6, minute: 30)),
          TimeRange(
              start: TimeOfDay(hour: 12, minute: 0),
              end: TimeOfDay(hour: 14, minute: 0)),
          TimeRange(
              start: TimeOfDay(hour: 22, minute: 0),
              end: TimeOfDay(hour: 23, minute: 59))
        ]);

    // TODO : Proper "environment detection"
    _detectedController.add(_environments["Home Office"]!);
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
    if (_environments.containsKey(environmentId)) {
      return Future.value(false);
    }

    _environments.remove(environmentId);
    _updateEnvironments();
    return Future.value(true);
  }

  @override
  Future<bool> updateEnvironment(
      {required String environmentId, required Environment environment}) {
    if (_environments.containsKey(environment.name)) {
      return Future.value(false);
    }

    _environments[environment.name] = environment;
    _updateEnvironments();
    return Future.value(true);
  }

  @override
  Stream<Environment> streamDetected() => _detectedController.stream;

  @override
  Stream<List<Environment>> streamEnvironments() => _knownController.stream;

  void dispose() {
    _detectedController.close();
    _knownController.close();
  }
}
