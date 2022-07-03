import 'package:beaconscious/repositories/detection/models/detector.dart';
import 'package:beaconscious/repositories/environments/models/day_time_window.dart';
import 'package:beaconscious/repositories/environments/models/rules/rules.dart';
import 'package:beaconscious/repositories/environments/models/time_range.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Environment extends Equatable {
  final IconData icon;
  final String name;
  final List<String> where;
  final List<DayTimeWindow> when;
  final List<Rule> what;

  const Environment(
      {required this.icon,
      required this.name,
      required this.where,
      required this.when,
      required this.what});

  Environment copyWith(
          {IconData? icon,
          String? name,
          List<String>? where,
          List<DayTimeWindow>? when,
          List<Rule>? what}) =>
      Environment(
          icon: icon ?? this.icon,
          name: name ?? this.name,
          where: where ?? this.where,
          when: when ?? this.when,
          what: what ?? this.what);

  @override
  List<Object?> get props => [icon, name, where, when, what];

  @override
  bool get stringify => true;

  static const empty = Environment(
      icon: Icons.error,
      name: "",
      when: <DayTimeWindow>[],
      where: <String>[],
      what: <Rule>[]);

  bool get isEmpty => this == Environment.empty;

  bool get isNotEmpty => this != Environment.empty;
}
