import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDateUtils {
  static String getWeekDayName(BuildContext context, DateTime dateTime) {
    var weekday = dateTime.weekday;

    switch (weekday) {
      case 1:
        return AppLocalizations.of(context)!.monday;
      case 2:
        return AppLocalizations.of(context)!.tuesday;
      case 3:
        return AppLocalizations.of(context)!.wednesday;
      case 4:
        return AppLocalizations.of(context)!.thursday;
      case 5:
        return AppLocalizations.of(context)!.friday;
      case 6:
        return AppLocalizations.of(context)!.saturday;
      case 7:
        return AppLocalizations.of(context)!.sunday;
      default:
        throw ArgumentError("$weekday is an unknown weekday.");
    }
  }

  static String getWeekDayShortName(BuildContext context, DateTime dateTime) {
    var weekday = dateTime.weekday;

    switch (weekday) {
      case 1:
        return AppLocalizations.of(context)!.monday_short;
      case 2:
        return AppLocalizations.of(context)!.tuesday_short;
      case 3:
        return AppLocalizations.of(context)!.wednesday_short;
      case 4:
        return AppLocalizations.of(context)!.thursday_short;
      case 5:
        return AppLocalizations.of(context)!.friday_short;
      case 6:
        return AppLocalizations.of(context)!.saturday_short;
      case 7:
        return AppLocalizations.of(context)!.sunday_short;
      default:
        throw ArgumentError("$weekday is an unknown weekday.");
    }
  }
}
