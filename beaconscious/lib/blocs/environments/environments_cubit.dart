import 'dart:async';
import 'dart:developer';

import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/environments/models/models.dart';

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
    var environments = state.environments;
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

  /// Removes a rule from the environment.
  Future<void> removeRule(
      {required String environmentId, required Rule rule}) async {
    final environment = state.environments.firstWhere(
        (element) => element.name == environmentId,
        orElse: () => Environment.empty);
    if (environment.isEmpty) {
      return;
    }

    final rules = [...environment.what]
      ..removeWhere((element) => element.runtimeType == rule.runtimeType);
    log("Deleted ${rule.runtimeType} from $environmentId");
    final updated = environment.copyWith(what: rules);

    await _repository.updateEnvironment(
        environmentId: environmentId, environment: updated);
  }

  /// Adds a rule to the environment.
  Future<void> addRule(
      {required String environmentId, required Rule rule}) async {
    final environment = state.environments.firstWhere(
        (element) => element.name == environmentId,
        orElse: () => Environment.empty);
    if (environment.isEmpty) {
      return;
    }

    // Distinct rule types!
    if (environment.what.any((e) => e.runtimeType == rule.runtimeType)) {
      return;
    }

    // TODO : distinct rule types
    final rules = [...environment.what, rule];
    log("Added ${rule.runtimeType} to $environmentId");
    final updated = environment.copyWith(what: rules);

    await _repository.updateEnvironment(
        environmentId: environmentId, environment: updated);
  }

  /// Adds a known detector to the environment.
  Future<void> addDetector(
      {required String environmentId, required String detectorId}) async {
    var current = state.environments.firstWhere(
        (element) => element.name == environmentId,
        orElse: () => Environment.empty);

    if (current.isEmpty || current.where.contains(detectorId)) {
      return;
    }

    log("Adding $detectorId to $environmentId");

    await _repository.updateEnvironment(
        environmentId: environmentId,
        environment: Environment(
            icon: current.icon,
            name: current.name,
            when: current.when,
            what: current.what,
            where: [...current.where, detectorId]));
  }

  /// Removes a known detector from the environment.
  Future<void> removeDetector(
      {required String environmentId, required String detectorId}) async {
    var current = state.environments.firstWhere(
        (element) => element.name == environmentId,
        orElse: () => Environment.empty);

    if (current.isEmpty || !current.where.contains(detectorId)) {
      return;
    }

    log("Removing $detectorId from $environmentId");

    var updated = [...current.where];
    updated.remove(detectorId);

    await _repository.updateEnvironment(
        environmentId: environmentId,
        environment: Environment(
            icon: current.icon,
            name: current.name,
            when: current.when,
            what: current.what,
            where: updated));
  }

  /// Add an environment to the list of known and detectable environments.
  Future<void> addEnvironment({required Environment environment}) async {
    // TODO : Distinct environments
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
