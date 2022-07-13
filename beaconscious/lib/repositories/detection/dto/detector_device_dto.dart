import 'package:beaconscious/repositories/detection/dto/detector_dto.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';

class DetectorDeviceDTO extends DetectorDTO {
  final String bluetoothName;

  const DetectorDeviceDTO(
      {required this.bluetoothName,
      required String id,
      required String name,
      required DateTime creationDate})
      : super(id: id, name: name, creationDate: creationDate);

  @override
  Map<String, dynamic> toFirestore() => {
        "id": id,
        "name": name,
        "creationDate": creationDate,
        "bluetoothName": bluetoothName,
        "type": "device"
      };

  @override
  Detector toModel() => Device(
      id: id,
      name: name,
      creationDate: creationDate,
      bluetoothName: bluetoothName);

  @override
  List<Object?> get props => super.props..addAll([bluetoothName]);
}
