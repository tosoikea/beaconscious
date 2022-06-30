import 'dart:async';

import 'package:beaconscious/blocs/detection/detection_state.dart';
import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetectionCubit extends Cubit<DetectionState> {
  final DetectionRepository _repository;
  late final StreamSubscription<List<Detector>> _detectionSubscription;
  late final StreamSubscription<List<Detector>> _knownSubscription;

  DetectionCubit(this._repository) : super(DetectionState.initial()) {
    _detectionSubscription =
        _repository.streamDetected().listen(_onDetectionChanged);
    _knownSubscription = _repository.streamDetectors().listen(_onKnownChanged);
  }

  void _onDetectionChanged(List<Detector> detected) {
    emit(state.copyWith(detected: detected));
  }

  void _onKnownChanged(List<Detector> detectors) {
    emit(state.copyWith(detectors: detectors));
  }

  /// Loads the currently addable devices.
  Future<void> load() async {
    final devices = await _repository.getDevices();
    emit(state.copyWith(addable: devices));
  }

  @override
  Future<void> close() {
    _detectionSubscription.cancel();
    _knownSubscription.cancel();
    return super.close();
  }
}
