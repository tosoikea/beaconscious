import 'package:beaconscious/repositories/detection/models/detector.dart';

import 'models/device.dart';

abstract class DetectionRepository {
  const DetectionRepository();

  Future<bool> addDetector({required Detector detector});
  Future<bool> removeDetector({required String detectorId});

  /// Returns all devices currently known to the application.
  Stream<List<Detector>> streamDetectors();

  /// Returns a stream that updates with the detected things.
  Stream<List<Detector>> streamDetected();

  /// Detect all close by (bluetooth) devices
  Future<List<Device>> getDevices();
}
