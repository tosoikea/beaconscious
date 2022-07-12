import 'dart:async';
import 'dart:developer';

import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/environments/models/models.dart';

typedef EnvironmentDeterminedCallback = Future<void> Function(
    Environment environment);

class EnvironmentsCubit extends Cubit<EnvironmentsState> {
  final EnvironmentsRepository _repository;
  late final StreamSubscription<List<Detector>> _detectionSubscription;
  late final StreamSubscription<List<Environment>> _knownSubscription;
  List<Detector> _detected;

  EnvironmentsCubit(this._repository, DetectionRepository detectionRepository)
      : _detected = <Detector>[],
        super(EnvironmentsState.initial()) {
    _detectionSubscription =
        detectionRepository.streamDetected().listen(_onDetectionChanged);
    _knownSubscription =
        _repository.streamEnvironments().listen(_onKnownChanged);
  }

  void _detect() {
    var environments = state.environments.where((element) => !element.disabled);
    var possible = <Environment>[Environment.empty];

    // A) Where
    for (var environment in environments) {
      if (environment.where
          .every((outer) => _detected.any((inner) => inner.id == outer))) {
        possible.add(environment);
      }
    }

    // TODO : Add time evaluation
    log("Detected ${environments.length} environments. Selecting last.");
    emit(state.copyWith(current: possible.last));
    log("Changed detection to ${possible.last}");
  }

  void _onDetectionChanged(List<Detector> detected) {
    log("Detected ${detected.length} detectors. Updating.");
    _detected = detected;
    _detect();
  }

  void _onKnownChanged(List<Environment> environments) {
    log("Knowing ${environments.length} environments. Updating.");
    emit(state.copyWith(environments: environments));
    _detect();
  }

  Future<void> _apply(
      {required EnvironmentDeterminedCallback callback,
      required String environmentId}) async {
    final current = state.environments.firstWhere(
        (element) => element.name == environmentId,
        orElse: () => Environment.empty);
    if (current.isEmpty) {
      return;
    }

    await callback(current);
  }

  /// Removes a rule from the environment.
  Future<void> removeRule(
          {required String environmentId, required Rule rule}) async =>
      await _apply(
          environmentId: environmentId,
          callback: (current) async {
            final rules = [...current.what]..removeWhere(
                (element) => element.runtimeType == rule.runtimeType);
            log("Deleted ${rule.runtimeType} from $environmentId");
            final updated = current.copyWith(what: rules);

            await _repository.updateEnvironment(
                environmentId: environmentId, environment: updated);
          });

  /// Adds a rule to the environment.
  Future<void> addRule(
          {required String environmentId, required Rule rule}) async =>
      await _apply(
          environmentId: environmentId,
          callback: (current) async {
            // Distinct rule types!
            if (current.what.any((e) => e.runtimeType == rule.runtimeType)) {
              return;
            }

            // TODO : distinct rule types
            final rules = [...current.what, rule];
            log("Added ${rule.runtimeType} to $environmentId");
            final updated = current.copyWith(what: rules);

            await _repository.updateEnvironment(
                environmentId: environmentId, environment: updated);
          });

  /// Adds a known detector to the environment.
  Future<void> addDetector(
          {required String environmentId, required String detectorId}) async =>
      await _apply(
          environmentId: environmentId,
          callback: (current) async {
            if (current.where.contains(detectorId)) {
              return;
            }

            log("Adding $detectorId to $environmentId");

            await _repository.updateEnvironment(
                environmentId: environmentId,
                environment:
                    current.copyWith(where: [...current.where, detectorId]));
          });

  /// Disables the environment. This leads to it not being detectable.
  Future<void> disableEnvironment({required Environment environment}) async =>
      await _apply(
          environmentId: environment.name,
          callback: (current) async {
            log("Disabling ${current.name}");

            await _repository.updateEnvironment(
                environmentId: current.name,
                environment: current.copyWith(disabled: true));
          });

  /// Enables the environment for detection etc.
  Future<void> enableEnvironment({required Environment environment}) async =>
      await _apply(
          environmentId: environment.name,
          callback: (current) async {
            log("Enabling ${current.name}");

            await _repository.updateEnvironment(
                environmentId: current.name,
                environment: current.copyWith(disabled: false));
          });

  /// Removes a known detector from the environment.
  Future<void> removeDetector(
          {required String environmentId, required String detectorId}) async =>
      await _apply(
          environmentId: environmentId,
          callback: (current) async {
            if (!current.where.contains(detectorId)) {
              return;
            }

            log("Removing $detectorId from $environmentId");

            var updated = [...current.where];
            updated.remove(detectorId);

            await _repository.updateEnvironment(
                environmentId: environmentId,
                environment: current.copyWith(where: updated));
          });

  /// Add an environment to the list of known and detectable environments.
  /// The added environment is disabled by default.
  Future<void> addEnvironment(
      {required String name, required IconData icon}) async {
    // TODO : Distinct environments
    final environment = Environment(
        icon: icon,
        disabled: true,
        name: name,
        where: const [],
        when: List.generate(
            7, (index) => DayTimeWindow(weekDay: index + 1, ranges: const [])),
        what: const []);

    await _repository.addEnvironment(environment: environment);
  }

  /// Remove an environment from the list of known and detectable environments.
  Future<void> removeEnvironment({required Environment environment}) async {
    // TODO : Afterwards the state needs to include information about the success of the operation etc.
    await _repository.removeEnvironment(environmentId: environment.name);
  }

  @override
  Future<void> close() {
    _detectionSubscription.cancel();
    _knownSubscription.cancel();
    return super.close();
  }
}
