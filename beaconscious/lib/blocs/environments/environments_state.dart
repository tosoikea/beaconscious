import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:equatable/equatable.dart';

enum EnvironmentsStatus { initial, loading, success, failure }

class EnvironmentsState extends Equatable {
  final Environment current;
  final List<Environment> environments;
  final EnvironmentsStatus status;

  EnvironmentsState._internal(
      {Environment? current,
      List<Environment>? environments,
      this.status = EnvironmentsStatus.initial})
      : current = current ?? Environment.empty,
        environments = environments ?? <Environment>[];

  EnvironmentsState.initial() : this._internal();

  EnvironmentsState copyWith(
          {Environment? current,
          List<Environment>? environments,
          EnvironmentsStatus? status}) =>
      EnvironmentsState._internal(
          current: current ?? this.current,
          environments: environments ?? this.environments,
          status: status ?? this.status);

  @override
  List<Object?> get props => [current, environments, status];
}
