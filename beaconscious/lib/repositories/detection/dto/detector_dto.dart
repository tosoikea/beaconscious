import 'package:beaconscious/repositories/detection/dto/detector_device_dto.dart';
import 'package:beaconscious/repositories/detection/dto/detector_location_dto.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class DetectorDTO extends Equatable {
  final String id;
  final String name;
  final DateTime creationDate;

  const DetectorDTO(
      {required this.id, required this.name, required this.creationDate});

  factory DetectorDTO.fromModel(Detector detector) {
    if (detector is Device) {
      return DetectorDeviceDTO(
          bluetoothName: detector.bluetoothName,
          id: detector.id,
          name: detector.name,
          creationDate: detector.creationDate);
    } else if (detector is Location) {
      return DetectorLocationDTO(
          latitude: detector.latitude,
          longitude: detector.longitude,
          id: detector.id,
          name: detector.name,
          creationDate: detector.creationDate);
    } else {
      throw ArgumentError("Detector Type ${detector.runtimeType} is unknown");
    }
  }

  factory DetectorDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final id = snapshot.id;

    if (data == null) {
      throw ArgumentError("Can not handle null data.");
    }

    if (!data.containsKey("type")) {
      throw ArgumentError("Missing type attribute");
    }

    switch (data["type"]!) {
      case "device":
        return DetectorDeviceDTO(
            bluetoothName: data["bluetoothName"],
            id: id,
            name: data["name"],
            creationDate: (data["creationDate"] as Timestamp).toDate());
      case "location":
        return DetectorLocationDTO(
            latitude: data["latitude"],
            longitude: data["longitude"],
            id: id,
            name: data["name"],
            creationDate: (data["creationDate"] as Timestamp).toDate());
      default:
        throw ArgumentError("Invalid ${data["type"]!} type attribute");
    }
  }

  Map<String, dynamic> toFirestore();

  Detector toModel();

  @override
  List<Object?> get props => [id, name, creationDate];
}
