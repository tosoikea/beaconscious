import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/widgets/current_analysis_widget.dart';
import 'package:beaconscious/widgets/current_detection_widget.dart';
import 'package:beaconscious/widgets/current_environment_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends BeaconsciousPage {
  const HomePage() : super(key: const ValueKey("HomePage"));

  @override
  Widget get child => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              CurrentEnvironmentWidget(),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CurrentAnalysisWidget(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CurrentDetectionWidget(),
              )
            ],
          ),
        ),
      );
}
