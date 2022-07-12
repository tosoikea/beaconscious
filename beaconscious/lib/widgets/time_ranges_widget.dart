import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/time_of_day_utils.dart';
import 'package:flutter/material.dart';

class _AnnotatedTimeRange<T> {
  final TimeRange range;
  final T annotation;

  const _AnnotatedTimeRange(this.range, this.annotation);
}

class TimeRangesWidget extends StatelessWidget {
  final List<TimeRange> ranges;

  const TimeRangesWidget({super.key, required this.ranges});

  TimeOfDay _subtractMinute(TimeOfDay time) {
    if (time.minute > 0) {
      return time.replacing(minute: time.minute - 1);
    } else if (time.hour > 0) {
      return time.replacing(hour: time.hour - 1, minute: 59);
    } else {
      // Minimum reached
      return time;
    }
  }

  TimeOfDay _addMinute(TimeOfDay time) {
    if (time.minute < 59) {
      return time.replacing(minute: time.minute + 1);
    } else if (time.hour < 23) {
      return time.replacing(hour: time.hour + 1, minute: 0);
    } else {
      // Maximum reached
      return time;
    }
  }

  List<_AnnotatedTimeRange<bool>> _getFilled() {
    var res = <_AnnotatedTimeRange<bool>>[];
    var current = const TimeOfDay(hour: 0, minute: 0);
    var end = const TimeOfDay(hour: 23, minute: 59);

    for (var range in ranges) {
      if (current != range.start) {
        var prefix =
            TimeRange(start: current, end: _subtractMinute(range.start));
        res.add(_AnnotatedTimeRange(prefix, false));
      }
      res.add(_AnnotatedTimeRange(range, true));
      current = _addMinute(range.end);
    }

    if (current != end) {
      var suffix =
          TimeRange(start: current, end: const TimeOfDay(hour: 23, minute: 59));
      res.add(_AnnotatedTimeRange(suffix, false));
    }

    return res;
  }

  @override
  Widget build(BuildContext context) => Row(
        children: _getFilled().map((e) {
          var difference =
              TimeOfDayUtils.difference(end: e.range.end, start: e.range.start);

          return Flexible(
            flex: difference.hour * 60 + difference.minute,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO : Change style, only for prototype to work...
                if (e.annotation && difference.hour > 2)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(TimeOfDayUtils.getPadded(e.range.start),
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                      color: (e.annotation)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      borderRadius:
                          (e.range.start == const TimeOfDay(hour: 0, minute: 0))
                              ? const BorderRadius.horizontal(
                                  left: Radius.circular(12))
                              : (e.range.end ==
                                      const TimeOfDay(hour: 23, minute: 59))
                                  ? const BorderRadius.horizontal(
                                      right: Radius.circular(12))
                                  : null),
                ),
                // TODO : Change style, only for prototype to work...
                if (e.annotation && difference.hour > 2)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(TimeOfDayUtils.getPadded(e.range.end),
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
              ],
            ),
          );
        }).toList(),
      );
}
