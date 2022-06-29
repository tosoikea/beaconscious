import 'package:beaconscious/repositories/detection/models/detector.dart';
import 'package:equatable/equatable.dart';

enum DetectionStatus { initial, loading, success, failure }

class DetectionState extends Equatable {
  final List<Detector> detectors;
  final List<Detector> detected;
  final DetectionStatus status;

  DetectionState._internal(
      {List<Detector>? detected,
      List<Detector>? detectors,
      this.status = DetectionStatus.initial})
      : detected = detected ?? <Detector>[],
        detectors = detectors ?? <Detector>[];

  DetectionState.initial() : this._internal();

  DetectionState copyWith(
          {List<Detector>? detected,
          List<Detector>? detectors,
          DetectionStatus? status}) =>
      DetectionState._internal(
          detected: detected ?? this.detected,
          detectors: detectors ?? this.detectors,
          status: status ?? this.status);

  @override
  List<Object?> get props => [detected, detectors, status];
}
