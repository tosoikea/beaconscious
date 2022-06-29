import 'dart:async';

import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/environments/models/models.dart';

class EnvironmentsCubit extends Cubit<EnvironmentsState> {
  late final StreamSubscription<Environment> _detectionSubscription;
  late final StreamSubscription<List<Environment>> _knownSubscription;

  EnvironmentsCubit(EnvironmentsRepository repository)
      : super(EnvironmentsState.initial()) {
    _detectionSubscription =
        repository.streamDetected().listen(_onDetectionChanged);
    _knownSubscription =
        repository.streamEnvironments().listen(_onKnownChanged);
  }

  void _onDetectionChanged(Environment environment) {
    emit(state.copyWith(current: environment));
  }

  void _onKnownChanged(List<Environment> environments) {
    emit(state.copyWith(environments: environments));
  }

  @override
  Future<void> close() {
    _detectionSubscription.cancel();
    _knownSubscription.cancel();
    return super.close();
  }
}
