import 'package:beaconscious/repositories/detection/models/models.dart';
import 'package:flutter/material.dart';

class DetectorIconVisitor extends DetectorVisitor<BuildContext, IconData> {
  @override
  IconData visitDevice(Device device, BuildContext state) =>
      Icons.devices_other_rounded;

  @override
  IconData visitLocation(Location location, BuildContext state) =>
      Icons.location_on;
}
