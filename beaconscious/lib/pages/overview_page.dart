import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class OverviewPage extends BeaconsciousPage {
  const OverviewPage() : super(key: const ValueKey("OverviewPage"));

  @override
  Widget get child => Text("Overview");
}
