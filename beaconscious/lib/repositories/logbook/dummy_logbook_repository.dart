import 'package:beaconscious/repositories/logbook/logbook_repository.dart';
import 'package:beaconscious/repositories/logbook/models/models.dart';

class DummyLogbookRepository extends LogbookRepository {
  const DummyLogbookRepository();

  @override
  Future<List<LogbookEntry>> getEntries({required String environmentId}) {
    var days = [
      Date.fromDateTime(DateTime.now().subtract(const Duration(days: 6))),
      Date.fromDateTime(DateTime.now().subtract(const Duration(days: 5))),
      Date.fromDateTime(DateTime.now().subtract(const Duration(days: 4))),
      Date.fromDateTime(DateTime.now().subtract(const Duration(days: 3))),
      Date.fromDateTime(DateTime.now().subtract(const Duration(days: 2))),
      Date.fromDateTime(DateTime.now().subtract(const Duration(days: 1))),
      Date.fromDateTime(DateTime.now())
    ];

    return Future.value(<LogbookEntry>[
      LogbookEntry(
          environmentId: environmentId,
          date: days[0],
          seconds: 8 * 60 * 60 + 12 * 60),
      LogbookEntry(
          environmentId: environmentId,
          date: days[1],
          seconds: 7 * 60 * 60 + 15 * 60),
      LogbookEntry(
          environmentId: environmentId,
          date: days[2],
          seconds: 5 * 60 * 60 + 20 * 60),
      LogbookEntry(
          environmentId: environmentId,
          date: days[3],
          seconds: 1 * 60 * 60 + 11 * 60),
      LogbookEntry(environmentId: "Home Office", date: days[4], seconds: 0),
      LogbookEntry(
          environmentId: environmentId,
          date: days[5],
          seconds: 9 * 60 * 60 + 12 * 60),
      LogbookEntry(
          environmentId: environmentId,
          date: days[6],
          seconds: 2 * 60 * 60 + 18 * 60),
    ]);
  }

  @override
  Future<bool> logDetection(
      {required String environmentId, required int seconds}) {
    // TODO: implement logDetection
    throw UnimplementedError();
  }
}
