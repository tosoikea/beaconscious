import 'package:beaconscious/repositories/detection/models/detector.dart';
import 'package:beaconscious/repositories/detection/models/detector_visitor.dart';

class Location extends Detector {
  final double latitude;
  final double longitude;

  const Location(
      {required String id,
      required String name,
      required DateTime creationDate,
      required this.latitude,
      required this.longitude})
      : super(id: id, name: name, creationDate: creationDate);

  @override
  O accept<I, O>(DetectorVisitor<I, O> visitor, I state) =>
      visitor.visitLocation(this, state);

  Location copyWith(
          {String? id,
          String? name,
          DateTime? creationDate,
          double? latitude,
          double? longitude}) =>
      Location(
          id: id ?? this.id,
          name: name ?? this.name,
          creationDate: creationDate ?? this.creationDate,
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.longitude);

  @override
  List<Object?> get props => super.props..addAll([latitude, longitude]);

  static final empty = Location(
      id: "",
      name: "",
      latitude: 0,
      longitude: 0,
      creationDate: DateTime.fromMillisecondsSinceEpoch(0));

  bool get isEmpty => this == Location.empty;

  bool get isNotEmpty => this != Location.empty;
}
