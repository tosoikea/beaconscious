import 'dart:async';

import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/dto/detector_dto.dart';
import 'package:beaconscious/repositories/detection/dto/device_dto.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDetectionRepository extends DetectionRepository {
  const FirebaseDetectionRepository();

  @override
  Future<bool> addDetector({required Detector detector}) async {
    final store = FirebaseFirestore.instance;
    await store
        .collection("detectors")
        .add(DetectorDTO.fromModel(detector).toFirestore());

    return true;
  }

  @override
  Future<bool> removeDetector({required String detectorId}) async {
    final store = FirebaseFirestore.instance;
    await store.collection("detectors").doc(detectorId).delete();

    return true;
  }

  @override
  Stream<List<Detector>> streamDetected() {
    final store = FirebaseFirestore.instance;
    final base = store
        .collection("detectors")
        .withConverter(
            fromFirestore: DetectorDTO.fromFirestore,
            toFirestore: (DetectorDTO dto, _) => dto.toFirestore())
        .where("detected", isEqualTo: true)
        .snapshots();

    return base.map((event) =>
        event.docs.map((e) => e.data().toModel()).toList(growable: false));
  }

  @override
  Stream<List<Detector>> streamDetectors() {
    final store = FirebaseFirestore.instance;
    final base = store
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
            .collection("devices")
            .withConverter(
                fromFirestore: DeviceDTO.fromFirestore,
                toFirestore: (DeviceDTO dto, _) => dto.toFirestore())
            .get())
        .docs
        .map((e) => e.data().toModel());

    final detectors = (await store
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
