import 'package:beaconscious/repositories/logbook/logbook_repository.dart';
import 'package:beaconscious/repositories/logbook/models/models.dart';

class DummyLogbookRepository extends LogbookRepository {
  const DummyLogbookRepository();

  LogbookEntry _getSleepingEntry(DateTime day) {
    switch (day.weekday) {
      case 1:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 7 * 60 * 60 + 15 * 60);
      case 2:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 8 * 60 * 60 + 5 * 60);
      case 3:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 6 * 60 * 60 + 10 * 60);
      case 4:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 5 * 60 * 60 + 45 * 60);
      case 5:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 7 * 60 * 60 + 5 * 60);
      case 6:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 8 * 60 * 60 + 10 * 60);
      case 7:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 9 * 60 * 60 + 35 * 60);
      default:
        return LogbookEntry(
            environmentId: "Schlafen",
            date: Date.fromDateTime(day),
            seconds: 0);
    }
  }

  LogbookEntry _getFreeTimeEntry(DateTime day) {
    switch (day.weekday) {
      case 1:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 3 * 60 * 60 + 5 * 60);
      case 2:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 2 * 60 * 60 + 8 * 60);
      case 3:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 2 * 60 * 60 + 25 * 60);
      case 4:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 1 * 60 * 60 + 9 * 60);
      case 5:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 4 * 60 * 60 + 2 * 60);
      case 6:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 9 * 60 * 60 + 15 * 60);
      case 7:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 10 * 60 * 60 + 20 * 60);
      default:
        return LogbookEntry(
            environmentId: "Freizeit",
            date: Date.fromDateTime(day),
            seconds: 0);
    }
  }

  @override
  Future<List<LogbookEntry>> getEntries({required String environmentId}) {
    var days = [
      DateTime.now().subtract(const Duration(days: 6)),
      DateTime.now().subtract(const Duration(days: 5)),
      DateTime.now().subtract(const Duration(days: 4)),
      DateTime.now().subtract(const Duration(days: 3)),
      DateTime.now().subtract(const Duration(days: 2)),
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now()
    ];

    switch (environmentId) {
      case "Schlafen":
        return Future.value(days.map((e) => _getSleepingEntry(e)).toList());
      case "Freizeit":
        return Future.value(days.map((e) => _getFreeTimeEntry(e)).toList());
      default:
        return Future.value(days
            .map((e) => e == days[days.length - 1]
                ? LogbookEntry(
                    environmentId: environmentId,
                    date: Date.fromDateTime(e),
                    seconds: 5 * 60 * 60)
                : LogbookEntry(
                    environmentId: environmentId,
                    date: Date.fromDateTime(e),
                    seconds: 0))
            .toList());
    }
  }

  @override
  Future<bool> logDetection(
      {required String environmentId, required int seconds}) {
    // TODO: implement logDetection
    throw UnimplementedError();
  }
}
