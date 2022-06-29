import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:flutter/material.dart';

class RuleIconVisitor extends RuleVisitor<BuildContext, IconData> {
  @override
  IconData visitDoNotDisturbRule(DoNotDisturbRule rule, BuildContext state) =>
      Icons.volume_off;

  @override
  IconData visitDisabledAppNotificationsRule(
          DisabledAppNotificationsRule rule, BuildContext state) =>
      Icons.notifications_off;
}
