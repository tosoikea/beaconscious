import 'dart:async';

import 'package:beaconscious/blocs/analysis/analysis.dart';
import 'package:beaconscious/blocs/analysis/analysis_state.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:beaconscious/repositories/logbook/logbook_repository.dart';
import 'package:beaconscious/repositories/logbook/models/logbook_entry.dart';
import 'package:beaconscious/repositories/logbook/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  late final StreamSubscription _navigationSubscription;
  final LogbookRepository _repository;

  AnalysisCubit(this._repository, NavigationCubit navigationCubit)
      : super(AnalysisState.initial()) {
    _navigationSubscription =
        navigationCubit.stream.listen(_onNavigationStateChanged);
  }

  void _onNavigationStateChanged(AppNavigationState state) async {
    if (state.context == AppNavigationContext.home ||
        state.context == AppNavigationContext.analysis) {
      await load();
    }
  }

  Future<void> load() async {
    emit(state.copyWith(status: AnalysisStatus.loading));

    var stored = await _repository.getEntries();

    // 1. This week : Last 7 Days (incl. today)
    var currentWeek = <String, List<LogbookEntry>>{};
    final start = DateTime.now().subtract(const Duration(days: 6));

    for (var entry in stored.entries) {
      var environmentId = entry.key;
      var environmentWeek = <LogbookEntry>[];

      for (var logEntry in entry.value) {
        if (logEntry.date.toDateTime().isAfter(start)) {
          environmentWeek.add(logEntry);
        }
      }

      currentWeek[environmentId] = environmentWeek;
    }

    // 2. Today
    final currentDay = <String, LogbookEntry>{};
    var today = DateTime.now();

    for (var entry in stored.entries) {
      var environmentId = entry.key;

      for (var logEntry in entry.value) {
        if (logEntry.date.toDateTime() ==
            DateTime(today.year, today.month, today.day)) {
          currentDay[environmentId] = logEntry;
        }
      }
    }

    emit(state.copyWith(
        currentDay: currentDay,
        currentWeek: currentWeek,
        status: AnalysisStatus.success));
  }

  @override
  Future<void> close() {
    _navigationSubscription.cancel();
    return super.close();
  }
}
