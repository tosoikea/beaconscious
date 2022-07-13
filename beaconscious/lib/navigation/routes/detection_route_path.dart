import 'package:beaconscious/navigation/routes/route_path.dart';

/// Route to the overview of the app
class DetectionRoutePath extends RoutePath {
  const DetectionRoutePath._internal();

  const DetectionRoutePath.overview() : this._internal();
}

class DetectionCreationRoutePath extends DetectionRoutePath {
  const DetectionCreationRoutePath.start() : super.overview();
}
