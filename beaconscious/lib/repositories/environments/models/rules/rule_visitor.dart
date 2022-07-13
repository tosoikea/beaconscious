import 'package:beaconscious/repositories/environments/models/rules/disabled_app_notifications_rule.dart';
import 'package:beaconscious/repositories/environments/models/rules/do_not_disturb_rule.dart';
import 'package:beaconscious/repositories/environments/models/rules/restricted_app_usage_rule.dart';

abstract class RuleVisitor<I, O> {
  O visitDoNotDisturbRule(DoNotDisturbRule rule, I state);

  O visitDisabledAppNotificationsRule(
      DisabledAppNotificationsRule rule, I state);

  O visitRestrictedAppUsageRule(RestrictedAppUsageRule rule, I state);
}
