import 'dart:async';
import 'dart:developer';

import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:beaconscious/utils/time_of_day_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/environments/models/models.dart';

typedef EnvironmentDeterminedCallback = Future<void> Function(
    Environment environment);

class EnvironmentsCubit extends Cubit<EnvironmentsState> {
  final EnvironmentsRepository _repository;
  late final Timer _refresh;
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
    _refresh =
        Timer.periodic(const Duration(seconds: 15), (timer) => _detect());
  }

  void _detect() {
    log("Evaluating environment detection");
    var environments = state.environments.where((element) => !element.disabled);

    // A) Where
    final wherePossible = <Environment>[];
    for (var environment in environments) {
      if (environment.where
          .every((outer) => _detected.any((inner) => inner.id == outer))) {
        wherePossible.add(environment);
      }
    }

    // B) When
    final now = DateTime.now();
    final whenPossible = <Environment>[Environment.empty];
    for (var environment in wherePossible) {
      if (environment.when
          .firstWhere((element) => element.weekDay == now.weekday)
          .ranges
          .any((range) =>
              TimeOfDayUtils.included(TimeOfDay.fromDateTime(now), range))) {
        whenPossible.add(environment);
      }
    }

    log("Detected ${whenPossible.length} environments. Selecting last.");
    emit(state.copyWith(current: whenPossible.last));
    log("Changed detection to ${whenPossible.last}");
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

  /// Removes a time range from the environment.
  Future<void> removeRange(
          {required String environmentId,
          required int weekDay,
          required TimeRange range}) async =>
      await _apply(
          environmentId: environmentId,
          callback: (current) async {
            final when = [...current.when]
                .map((e) => (e.weekDay == weekDay)
                    ? DayTimeWindow(
                        weekDay: weekDay,
                        ranges: [...e.ranges]
                          ..removeWhere((element) => element == range))
                    : e)
                .toList();

            final updated = current.copyWith(when: when);
            if (const ListEquality().equals(updated.when, current.when)) {
              log("Did not delete $range at $weekDay from $environmentId");
            } else {
              log("Deleted $range at $weekDay from $environmentId");
              await _repository.updateEnvironment(
                  environmentId: environmentId, environment: updated);
            }
          });

  /// Adds a rule to the environment.
  /// TODO : This can obviously be improved when assuming a sorted list...
  List<TimeRange> _mergeRanges(List<TimeRange> initial, TimeRange added) {
    var lookup = added;

    // Find intersection
    final res = <TimeRange>[];

    for (int i = 0; i < initial.length; i++) {
      final startIncluded = TimeOfDayUtils.included(initial[i].start, lookup);
      final endIncluded = TimeOfDayUtils.included(initial[i].end, lookup);

      // Added absorbs the time range
      if (startIncluded && endIncluded) {
        continue;
      }
      // Starting Part of an existing range is included in added range
      // Combine ranges and finish
      else if (startIncluded && !endIncluded) {
        lookup = TimeRange(start: lookup.start, end: initial[i].end);
      }
      // Ending Part of an existing range is included in added range
      // Combine ranges and finish
      else if (!startIncluded && endIncluded) {
        lookup = TimeRange(start: initial[i].start, end: lookup.end);
      }
      // No overlap, keep looking.
      else {
        res.add(initial[i]);
      }
    }

    res.add(lookup);
    return res..sort((a, b) => TimeOfDayUtils.compare(a.start, b.start));
  }

  Future<void> addRange(
          {required String environmentId,
          required int weekDay,
          required TimeRange range}) async =>
      await _apply(
          environmentId: environmentId,
          callback: (current) async {
            // TODO : Do not allow overlap of when
            final when = [...current.when]
                .map((e) => (e.weekDay == weekDay)
                    ? DayTimeWindow(
                        weekDay: weekDay, ranges: _mergeRanges(e.ranges, range))
                    : e)
                .toList();

            final updated = current.copyWith(when: when);

            if (const ListEquality().equals(updated.when, current.when)) {
              log("Did not add $range at $weekDay from $environmentId");
            } else {
              log("Added $range at $weekDay from $environmentId");
              await _repository.updateEnvironment(
                  environmentId: environmentId, environment: updated);
            }
          });

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
    _refresh.cancel();
    _detectionSubscription.cancel();
    _knownSubscription.cancel();
    return super.close();
  }
}
