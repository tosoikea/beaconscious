import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:equatable/equatable.dart';

enum DetectionStatus { initial, loading, success, failure }

class DetectionState extends Equatable {
  final List<Detector> detectors;
  final List<Detector> detected;
  final List<Device> addable;

  final DetectionStatus status;

  DetectionState._internal(
      {List<Detector>? detected,
      List<Detector>? detectors,
      List<Device>? addable,
      this.status = DetectionStatus.initial})
      : detected = detected ?? <Detector>[],
        detectors = detectors ?? <Detector>[],
        addable = addable ?? <Device>[];

  DetectionState.initial() : this._internal();

  DetectionState copyWith(
          {List<Detector>? detected,
          List<Detector>? detectors,
          List<Device>? addable,
          DetectionStatus? status}) =>
      DetectionState._internal(
          detected: detected ?? this.detected,
          detectors: detectors ?? this.detectors,
          addable: addable ?? this.addable,
          status: status ?? this.status);

  @override
  List<Object?> get props => [detected, detectors, addable, status];
}
