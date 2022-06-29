import 'package:beaconscious/repositories/environments/models/rules/do_not_disturb_rule.dart';

abstract class RuleVisitor<I, O> {
  O visitDoNotDisturbRule(DoNotDisturbRule rule, I state);
}
