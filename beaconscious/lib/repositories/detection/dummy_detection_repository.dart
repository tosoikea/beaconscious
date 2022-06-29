import 'dart:async';

import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';

class DummyDetectionRepository extends DetectionRepository {
  final StreamController<List<Detector>> _detectedController;
  final StreamController<List<Detector>> _knownController;
  final Map<String, Detector> _detectors;

  DummyDetectionRepository()
      : _detectors = <String, Detector>{},
        _detectedController = StreamController<List<Detector>>(),
        _knownController = StreamController<List<Detector>>() {
    _detectors["device-001"] = Device(
        id: "device-001",
        name: "Arbeitslaptop",
        creationDate: DateTime.now(),
        address: "aa:bb:cc:dd");

    _detectors["device-002"] = Device(
        id: "device-002",
        name: "Schlafzimmer",
        creationDate: DateTime.now(),
        address: "bb:cc:dd:ee");

    _detectors["location-001"] = Location(
        id: "location-001",
        name: "Zuhause",
        creationDate: DateTime.now(),
        latitude: 28.86998,
        longitude: -108.13503);

    // TODO : Proper "device etc. detection"
    _detectedController.add(_detectors.values
        .where((element) => element.id != "device-002")
        .toList(growable: false));
    _updateDetectors();
  }

  /// Appends the currently known environments to the stream.
  void _updateDetectors() =>
      _knownController.add(_detectors.values.toList(growable: false));

  @override
  Future<bool> addDetector({required Detector detector}) {
    if (_detectors.containsKey(detector.name)) {
      return Future.value(false);
    }

    _detectors[detector.name] = detector;
    _updateDetectors();
    return Future.value(true);
  }

  @override
  Future<bool> removeDetector({required String detectorId}) {
    if (_detectors.containsKey(detectorId)) {
      return Future.value(false);
    }

    _detectors.remove(detectorId);
    _updateDetectors();
    return Future.value(true);
  }

  @override
  Stream<List<Detector>> streamDetected() => _detectedController.stream;

  @override
  Stream<List<Detector>> streamDetectors() => _knownController.stream;

  void dispose() {
    _detectedController.close();
    _knownController.close();
  }
}
