import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:flutter/material.dart';

class TimeOfDayUtils {
  static TimeOfDay fromMinutes({required int minutes}) {
    int tHours = minutes ~/ 60;
    int tMinutes = minutes - (tHours * 60);

    return TimeOfDay(hour: tHours, minute: tMinutes);
  }

  static TimeOfDay difference(
      {required TimeOfDay end, required TimeOfDay start}) {
    var res = Duration(hours: end.hour, minutes: end.minute) -
        Duration(hours: start.hour, minutes: end.minute);

    if (res.isNegative) {
      throw ArgumentError("End ist smaller than start");
    }

    return fromMinutes(minutes: res.inMinutes);
  }

  static int compare(TimeOfDay a, TimeOfDay b) {
    int cmpHours = a.hour.compareTo(b.hour);

    if (cmpHours != 0) {
      return cmpHours;
    } else {
      return a.minute.compareTo(b.minute);
    }
  }

  static bool included(TimeOfDay a, TimeRange range) =>
      compare(a, range.start) >= 0 && compare(a, range.end) <= 0;

  static String getPadded(TimeOfDay a) =>
      "${a.hour.toString().padLeft(2, "0")}:${a.minute.toString().padLeft(2, "0")}";
}
