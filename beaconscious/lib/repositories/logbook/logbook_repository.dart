import 'package:beaconscious/repositories/logbook/models/models.dart';

abstract class LogbookRepository {
  /// This methods stores a detection of the given seconds for the current day for the given environment.
  Future<bool> logDetection(
      {required String environmentId, required int seconds});

  /// This method returns all known entries.
  /// TODO : A viable implementation would allow for filtering.
  Future<Map<String, List<LogbookEntry>>> getEntries();
}
