import 'package:beaconscious/repositories/logbook/models/logbook_entry.dart';
import 'package:equatable/equatable.dart';

enum AnalysisStatus { initial, loading, success, failure }

class AnalysisState extends Equatable {
  final AnalysisStatus status;

  final Map<String, List<LogbookEntry>> currentWeek;
  final Map<String, LogbookEntry> currentDay;

  AnalysisState._internal(
      {Map<String, List<LogbookEntry>>? currentWeek,
      Map<String, LogbookEntry>? currentDay,
      this.status = AnalysisStatus.initial})
      : currentWeek = currentWeek ?? <String, List<LogbookEntry>>{},
        currentDay = currentDay ?? <String, LogbookEntry>{};

  AnalysisState.initial() : this._internal();

  AnalysisState copyWith(
          {Map<String, List<LogbookEntry>>? currentWeek,
          Map<String, LogbookEntry>? currentDay,
          AnalysisStatus? status}) =>
      AnalysisState._internal(
          currentWeek: currentWeek ?? this.currentWeek,
          currentDay: currentDay ?? this.currentDay,
          status: status ?? this.status);

  @override
  List<Object?> get props => [status, currentWeek, currentDay];
}
