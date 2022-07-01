import 'package:flutter/material.dart';

class TimeOfDayUtils {
  static TimeOfDay fromMinutes({required int minutes}) {
    int tHours = minutes ~/ 60;
    int tMinutes = minutes - (tHours * 60);

    return TimeOfDay(hour: tHours, minute: tMinutes);
  }

  static TimeOfDay difference({required TimeOfDay end, required TimeOfDay start}) {
    var res = Duration(hours: end.hour, minutes: end.minute) -
        Duration(hours: start.hour, minutes: end.minute);

    if (res.isNegative) {
      throw ArgumentError("End ist smaller than start");
    }

    return fromMinutes(minutes: res.inMinutes);
  }
}
