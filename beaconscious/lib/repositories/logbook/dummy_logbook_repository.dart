import 'package:beaconscious/repositories/logbook/logbook_repository.dart';
import 'package:beaconscious/repositories/logbook/models/models.dart';

class DummyLogbookRepository extends LogbookRepository {
  final Map<String, List<LogbookEntry>> _entries;

  DummyLogbookRepository() : _entries = <String, List<LogbookEntry>>{} {
    var days = [
      Date.fromDateTime(DateTime.now().subtract(Duration(days: 6))),
      Date.fromDateTime(DateTime.now().subtract(Duration(days: 5))),
      Date.fromDateTime(DateTime.now().subtract(Duration(days: 4))),
      Date.fromDateTime(DateTime.now().subtract(Duration(days: 3))),
      Date.fromDateTime(DateTime.now().subtract(Duration(days: 2))),
      Date.fromDateTime(DateTime.now().subtract(Duration(days: 1))),
      Date.fromDateTime(DateTime.now())
    ];

    _entries["Home Office"] = [
      LogbookEntry(
          environmentId: "Home Office",
          date: days[0],
          seconds: 8 * 60 * 60 + 12 * 60),
      LogbookEntry(
          environmentId: "Home Office",
          date: days[1],
          seconds: 7 * 60 * 60 + 15 * 60),
      LogbookEntry(
          environmentId: "Home Office",
          date: days[2],
          seconds: 5 * 60 * 60 + 20 * 60),
      LogbookEntry(
          environmentId: "Home Office",
          date: days[3],
          seconds: 1 * 60 * 60 + 11 * 60),
      LogbookEntry(environmentId: "Home Office", date: days[4], seconds: 0),
      LogbookEntry(
          environmentId: "Home Office",
          date: days[5],
          seconds: 9 * 60 * 60 + 12 * 60),
      LogbookEntry(
          environmentId: "Home Office",
          date: days[6],
          seconds: 2 * 60 * 60 + 18 * 60),
    ];

    _entries["Schlafen"] = [
      LogbookEntry(
          environmentId: "Schlafen", date: days[0], seconds: 8 * 60 * 60),
      LogbookEntry(
          environmentId: "Schlafen", date: days[1], seconds: 8 * 60 * 60),
      LogbookEntry(
          environmentId: "Schlafen", date: days[2], seconds: 8 * 60 * 60),
      LogbookEntry(
          environmentId: "Schlafen", date: days[3], seconds: 8 * 60 * 60),
      LogbookEntry(
          environmentId: "Schlafen", date: days[4], seconds: 8 * 60 * 60),
      LogbookEntry(
          environmentId: "Schlafen", date: days[5], seconds: 8 * 60 * 60),
      LogbookEntry(
          environmentId: "Schlafen", date: days[6], seconds: 8 * 60 * 60),
    ];
  }

  @override
  Future<Map<String, List<LogbookEntry>>> getEntries() =>
      Future.value(_entries);

  @override
  Future<bool> logDetection(
      {required String environmentId, required int seconds}) {
    if (!_entries.containsKey(environmentId)) {
      _entries[environmentId] = [];
    }

    var date = Date.fromDateTime(DateTime.now());
    var lIndex = _entries[environmentId]!.length - 1;

    if (_entries[environmentId]!.isEmpty ||
        _entries[environmentId]![lIndex].date != date) {
      _entries[environmentId]!.add(LogbookEntry(
          environmentId: environmentId, date: date, seconds: seconds));
    } else {
      _entries[environmentId]![lIndex] = LogbookEntry(
          environmentId: environmentId,
          date: date,
          seconds: _entries[environmentId]![lIndex].seconds + seconds);
    }

    return Future.value(true);
  }
}
