import 'package:beaconscious/navigation/routes/route_path.dart';

/// Route to the overview of the app
class EnvironmentRoutePath extends RoutePath {
  final String environmentId;

  const EnvironmentRoutePath._internal(this.environmentId);

  const EnvironmentRoutePath.overview() : this._internal("");
  const EnvironmentRoutePath.details({required String environmentId})
      : this._internal(environmentId);
}

class EnvironmentCreationRoute extends EnvironmentRoutePath {
  const EnvironmentCreationRoute.start() : super.overview();
}
