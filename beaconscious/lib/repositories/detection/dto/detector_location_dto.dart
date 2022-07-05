import 'package:beaconscious/repositories/detection/dto/detector_dto.dart';
import 'package:beaconscious/repositories/detection/models/models.dart';

class DetectorLocationDTO extends DetectorDTO {
  final double latitude;
  final double longitude;

  const DetectorLocationDTO(
      {required this.latitude,
      required this.longitude,
      required String id,
      required String name,
      required DateTime creationDate,
      required bool detected})
      : super(
            id: id, name: name, creationDate: creationDate, detected: detected);

  @override
  Map<String, dynamic> toFirestore() => {
        "id": id,
        "name": name,
        "creationDate": creationDate,
        "latitude": latitude,
        "longitude": longitude,
        "detected": detected,
        "type": "location"
      };

  @override
  Detector toModel() => Location(
      id: id,
      name: name,
      creationDate: creationDate,
      latitude: latitude,
      longitude: longitude);

  @override
  List<Object?> get props => super.props..addAll([latitude, longitude]);
}
