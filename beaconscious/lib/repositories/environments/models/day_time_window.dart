import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DayTimeWindow extends Equatable {
  final int weekDay;
  final List<TimeRange> ranges;

  const DayTimeWindow({required this.weekDay, required this.ranges});

  @override
  List<Object?> get props => [weekDay, ranges];

  @override
  bool? get stringify => true;
}
