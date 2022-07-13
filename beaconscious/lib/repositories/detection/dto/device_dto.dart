import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DeviceDTO extends Equatable {
  final String name;
  final bool detected;

  const DeviceDTO({required this.name, required this.detected});

  factory DeviceDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return DeviceDTO(
        detected: data != null && data.containsKey("detected")
            ? data["detected"]!
            : "",
        name: data != null && data.containsKey("name") ? data["name"]! : "");
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name, "detected": detected};
  }

  @override
  List<Object?> get props => [name, detected];

  Device toModel() {
    return Device(
        id: name,
        name: name,
        creationDate: DateTime.now(),
        bluetoothName: name);
  }
}
