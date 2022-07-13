import 'package:beaconscious/repositories/detection/models/detector_visitor.dart';
import 'package:equatable/equatable.dart';

abstract class Detector extends Equatable {
  final String id;
  final String name;
  final DateTime creationDate;

  const Detector(
      {required this.id, required this.name, required this.creationDate});

  O accept<I, O>(DetectorVisitor<I, O> visitor, I state);

  @override
  List<Object?> get props => [id, name, creationDate];

  @override
  bool get stringify => true;
}
