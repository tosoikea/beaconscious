import 'package:beaconscious/repositories/detection/models/detector.dart';

abstract class DetectionRepository {
  Future<bool> addDetector({required Detector detector});
  Future<bool> removeDetector({required String detectorId});

  /// Returns all devices currently known to the application.
  Stream<List<Detector>> streamDetectors();

  /// Returns a stream that updates with the detected things.
  Stream<List<Detector>> streamDetected();
}
