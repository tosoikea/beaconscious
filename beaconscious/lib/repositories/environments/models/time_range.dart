import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TimeRange extends Equatable {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeRange({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];

  @override
  bool? get stringify => true;
}
