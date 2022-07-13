import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/repositories/environments/models/rules/restricted_app_usage_rule.dart';
import 'package:flutter/material.dart';

class RuleIconVisitor extends RuleVisitor<BuildContext, IconData> {
  @override
  IconData visitDoNotDisturbRule(DoNotDisturbRule rule, BuildContext state) =>
      Icons.volume_off;

  @override
  IconData visitDisabledAppNotificationsRule(
          DisabledAppNotificationsRule rule, BuildContext state) =>
      Icons.notifications_off;

  @override
  IconData visitRestrictedAppUsageRule(
          RestrictedAppUsageRule rule, BuildContext state) =>
      Icons.block_rounded;
}
