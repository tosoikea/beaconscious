import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TimeRange extends Equatable{
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end}) {
    assert((start.hour < end.hour) ||
        (start.hour == end.hour && start.minute < end.minute));
  }

  @override
  List<Object?> get props => [start, end];

  @override
  bool? get stringify => true;
}
