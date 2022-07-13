import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/repositories/environments/models/rules/restricted_app_usage_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RuleDescriptionVisitor extends RuleVisitor<BuildContext, Widget> {
  Widget _getAppsRow(List<String> applications) => Row(
      children: applications
          .map((e) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                        height: 16,
                        width: 16,
                        image: AssetImage("assets/images/$e.webp"))),
              ))
          .toList(growable: false));

  @override
  Widget visitDoNotDisturbRule(DoNotDisturbRule rule, BuildContext state) =>
      Text(
          AppLocalizations.of(state)!
              .environments_rule_do_not_disturb_description,
          style: Theme.of(state).textTheme.bodyMedium);

  @override
  Widget visitDisabledAppNotificationsRule(
          DisabledAppNotificationsRule rule, BuildContext state) =>
      _getAppsRow(rule.applications);

  @override
  Widget visitRestrictedAppUsageRule(
          RestrictedAppUsageRule rule, BuildContext state) =>
      _getAppsRow(rule.applications);
}
