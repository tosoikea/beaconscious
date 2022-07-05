import 'package:beaconscious/repositories/environments/models/rules/rule.dart';
import 'package:beaconscious/repositories/environments/models/rules/rule_visitor.dart';

class DoNotDisturbRule extends Rule {
  const DoNotDisturbRule();

  @override
  O accept<I, O>(RuleVisitor<I, O> visitor, I state) =>
      visitor.visitDoNotDisturbRule(this, state);
}
