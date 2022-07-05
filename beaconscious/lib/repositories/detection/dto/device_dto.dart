import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DeviceDTO extends Equatable {
  final String name;
  final String identifier;

  const DeviceDTO({required this.name, required this.identifier});

  factory DeviceDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final id = snapshot.id;

    return DeviceDTO(
        identifier: id,
        name: data != null && data.containsKey("name") ? data["name"]! : "");
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name};
  }

  @override
  List<Object?> get props => [identifier, name];

  Device toModel() {
    return Device(
        id: identifier,
        name: name,
        creationDate: DateTime.now(),
        bluetoothName: name);
  }
}
