import 'package:beaconscious/repositories/environments/models/rules/rule_visitor.dart';

/// Determines "What?" is to be done after an environment is detected.
abstract class Rule {
  const Rule();

  O accept<I, O>(RuleVisitor<I, O> visitor, I state);
}
