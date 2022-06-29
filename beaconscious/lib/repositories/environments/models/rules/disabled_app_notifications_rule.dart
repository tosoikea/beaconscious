import 'package:beaconscious/repositories/environments/models/rules/rule.dart';
import 'package:beaconscious/repositories/environments/models/rules/rule_visitor.dart';

class DisabledAppNotificationsRule extends Rule {
  // TODO : This is just for showing, obv. one would not store the app icons for identification.
  final List<String> applications;

  const DisabledAppNotificationsRule({required this.applications});

  @override
  O accept<I, O>(RuleVisitor<I, O> visitor, I state) =>
      visitor.visitDisabledAppNotificationsRule(this, state);
}
