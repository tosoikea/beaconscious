import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/repositories/environments/models/rules/restricted_app_usage_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RuleNameVisitor extends RuleVisitor<BuildContext, String> {
  @override
  String visitDoNotDisturbRule(DoNotDisturbRule rule, BuildContext state) =>
      AppLocalizations.of(state)!.environments_rule_do_not_disturb;

  @override
  String visitDisabledAppNotificationsRule(
          DisabledAppNotificationsRule rule, BuildContext state) =>
      AppLocalizations.of(state)!.environments_rule_no_app_notification;

  @override
  String visitRestrictedAppUsageRule(RestrictedAppUsageRule rule, BuildContext state) =>
      AppLocalizations.of(state)!.environments_rule_restricted_app_usage;
}
