import 'package:beaconscious/repositories/logbook/logbook_repository.dart';
import 'package:beaconscious/repositories/logbook/models/models.dart';

class DummyLogbookRepository extends LogbookRepository {
  final Map<String, List<LogbookEntry>> _entries;

  DummyLogbookRepository() : _entries = <String, List<LogbookEntry>>{} {
    _entries["Home Office"] = [
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 23),
          seconds: 8 * 60 * 60 + 12 * 60),
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 24),
          seconds: 7 * 60 * 60 + 15 * 60),
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 25),
          seconds: 5 * 60 * 60 + 20 * 60),
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 26),
          seconds: 1 * 60 * 60 + 11 * 60),
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 27),
          seconds: 0),
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 28),
          seconds: 9 * 60 * 60 + 12 * 60),
      const LogbookEntry(
          environmentId: "Home Office",
          date: Date(year: 2022, month: 6, day: 29),
          seconds: 2 * 60 * 60 + 18 * 60),
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
