import 'dart:async';
import 'dart:developer';

import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/environments/models/models.dart';

class EnvironmentsCubit extends Cubit<EnvironmentsState> {
  final EnvironmentsRepository _repository;
  late final StreamSubscription<Environment> _detectionSubscription;
  late final StreamSubscription<List<Environment>> _knownSubscription;

  EnvironmentsCubit(this._repository) : super(EnvironmentsState.initial()) {
    _detectionSubscription =
        _repository.streamDetected().listen(_onDetectionChanged);
    _knownSubscription =
        _repository.streamEnvironments().listen(_onKnownChanged);
  }

  void _onDetectionChanged(Environment environment) {
    log("Detection changed to ${environment.name}");
    emit(state.copyWith(current: environment));
  }

  void _onKnownChanged(List<Environment> environments) {
    log("Known environments updated");
    emit(state.copyWith(environments: environments));
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
