import 'package:beaconscious/repositories/environments/models/rules/rule.dart';
import 'package:beaconscious/repositories/environments/models/rules/rule_visitor.dart';

class RestrictedAppUsageRule extends Rule {
  final List<String> applications;

  const RestrictedAppUsageRule({required this.applications});

  @override
  O accept<I, O>(RuleVisitor<I, O> visitor, I state) =>
      visitor.visitRestrictedAppUsageRule(this, state);
}
