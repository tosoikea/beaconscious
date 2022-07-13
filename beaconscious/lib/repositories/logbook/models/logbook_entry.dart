import 'package:beaconscious/repositories/logbook/models/date.dart';
import 'package:equatable/equatable.dart';

class LogbookEntry extends Equatable {
  final String environmentId;
  final Date date;
  final int seconds;

  const LogbookEntry(
      {required this.environmentId, required this.date, required this.seconds});

  @override
  List<Object?> get props => [environmentId, date, seconds];
}
