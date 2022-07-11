import 'dart:async';

import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/dto/detector_dto.dart';
import 'package:beaconscious/repositories/detection/dto/device_dto.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_transform/stream_transform.dart';

class FirebaseDetectionRepository extends DetectionRepository {
  /// DETERMINES IN WHICH EXPERIMENTS CONTEXT IT RUNS
  static const int _experiment = 1;

  CollectionReference<DetectorDTO> _getDetectors() => FirebaseFirestore.instance
      .collection("experiments")
      .doc(_experiment.toString())
      .collection("detectors")
      .withConverter(
          fromFirestore: DetectorDTO.fromFirestore,
          toFirestore: (DetectorDTO dto, _) => dto.toFirestore());

  CollectionReference<DeviceDTO> _getDevices() => FirebaseFirestore.instance
      .collection("experiments")
      .doc(_experiment.toString())
      .collection("devices")
      .withConverter(
          fromFirestore: DeviceDTO.fromFirestore,
          toFirestore: (DeviceDTO dto, _) => dto.toFirestore());

  ///

  const FirebaseDetectionRepository();

  @override
  Future<bool> addDetector({required Detector detector}) async {
    await _getDetectors().add(DetectorDTO.fromModel(detector));
    return true;
  }

  @override
  Future<bool> removeDetector({required String detectorId}) async {
    await _getDetectors().doc(detectorId).delete();
    return true;
  }

  @override
  Stream<List<Detector>> streamDetected() {
    final detectorStream = _getDetectors().snapshots();
    final deviceStream = _getDevices().snapshots();

    return detectorStream
        .combineLatest<QuerySnapshot<DeviceDTO>, List<Detector>>(deviceStream,
            (dtcs, devs) {
      final devices = <String, DeviceDTO>{};
      for (var element in devs.docs) {
        devices[element.data().name] = element.data();
      }

      final detectors = dtcs.docs.map((e) => e.data().toModel());

      final detected = <Detector>[];
      for (var detector in detectors) {
        if (detector is Location) {
          // TODO : Locations
        } else if (detector is Device) {
          if (devices.containsKey(detector.bluetoothName) &&
              devices[detector.bluetoothName]!.detected) {
            detected.add(detector);
          }
        } else {
          throw ArgumentError("${detector.runtimeType} is unknown");
        }
      }

      return detected;
    });
  }

  @override
  Stream<List<Detector>> streamDetectors() {
    final store = FirebaseFirestore.instance;
    final base = store
        .collection("experiments")
        .doc(_experiment.toString())
        .collection("detectors")
        .withConverter(
            fromFirestore: DetectorDTO.fromFirestore,
            toFirestore: (DetectorDTO dto, _) => dto.toFirestore())
        .snapshots();

    return base.map((event) =>
        event.docs.map((e) => e.data().toModel()).toList(growable: false));
  }

  @override
  Future<List<Device>> getDevices() async {
    final store = FirebaseFirestore.instance;
    final base = (await store
            .collection("experiments")
            .doc(_experiment.toString())
            .collection("devices")
            .withConverter(
                fromFirestore: DeviceDTO.fromFirestore,
                toFirestore: (DeviceDTO dto, _) => dto.toFirestore())
            .where("detected", isEqualTo: true)
            .get())
        .docs
        .map((e) => e.data().toModel());

    final detectors = (await store
            .collection("experiments")
            .doc(_experiment.toString())
            .collection("detectors")
            .withConverter(
                fromFirestore: DetectorDTO.fromFirestore,
                toFirestore: (DetectorDTO dto, _) => dto.toFirestore())
            .get())
        .docs
        .map((e) => e.data().toModel());

    return base
        .where((e) => !detectors.any((inner) =>
            inner is Device && inner.bluetoothName == e.bluetoothName))
        .toList(growable: false);
  }
}
