import 'package:beaconscious/repositories/detection/models/detector.dart';
import 'package:beaconscious/repositories/detection/models/detector_visitor.dart';

class Device extends Detector {
  final String address;

  const Device({
    required String id,
    required String name,
    required DateTime creationDate,
    required this.address,
  }) : super(id: id, name: name, creationDate: creationDate);

  @override
  O accept<I, O>(DetectorVisitor<I, O> visitor, I state) =>
      visitor.visitDevice(this, state);

  Device copyWith(
          {String? id,
          String? name,
          DateTime? creationDate,
          String? address}) =>
      Device(
          id: id ?? this.id,
          name: name ?? this.name,
          creationDate: creationDate ?? this.creationDate,
          address: address ?? this.address);

  @override
  List<Object?> get props => super.props..addAll([address]);

  static final empty = Device(
      id: "",
      name: "",
      address: "",
      creationDate: DateTime.fromMillisecondsSinceEpoch(0));

  bool get isEmpty => this == Device.empty;

  bool get isNotEmpty => this != Device.empty;
}
