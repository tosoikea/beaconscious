import 'package:beaconscious/repositories/detection/models/models.dart';

abstract class DetectorVisitor<I, O> {
  O visitDevice(Device device, I state);
  O visitLocation(Location location, I state);
}
