import 'dart:developer';

import 'package:beaconscious/navigation/routes/routes.dart';
import 'package:flutter/widgets.dart';

class BeaconsciousRouteInformationParser
    extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    var uri = Uri.parse(routeInformation.location!);

    /// 1) The user supplied a "/" -> Show home screen
    if (uri.pathSegments.isEmpty) {
      log("$uri is mapped to home overview");
      return HomeRoutePath.overview();
    }

    log("$uri has ${uri.pathSegments.length} segments");
    switch (uri.pathSegments[0].toLowerCase()) {
      case "home":
        switch (uri.pathSegments.length) {
          case 1:
            return HomeRoutePath.overview();
          default:
            return UnknownRoutePath();
        }
      case "environment":
        switch (uri.pathSegments.length) {
          case 1:
            return const EnvironmentRoutePath.overview();
          case 2:
            return EnvironmentRoutePath.details(
                environmentId: uri.pathSegments[1]);
          default:
            return UnknownRoutePath();
        }
      case "analysis":
        switch (uri.pathSegments.length) {
          case 1:
            return const AnalysisRoutePath.overview();
          default:
            return UnknownRoutePath();
        }
      case "detection":
        switch (uri.pathSegments.length) {
          case 1:
            return const DetectionRoutePath.overview();
          default:
            return UnknownRoutePath();
        }
      default:
        return UnknownRoutePath();
    }
  }
}
