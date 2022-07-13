import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/rule_description_visitor.dart';
import 'package:beaconscious/utils/rule_icon_visitor.dart';
import 'package:beaconscious/utils/rule_name_visitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RuleWidget extends StatelessWidget {
  final Rule rule;
  final Environment environment;

  const RuleWidget({super.key, required this.rule, required this.environment});

  @override
  Widget build(BuildContext context) => Dismissible(
        direction: DismissDirection.startToEnd,
        background: Container(color: Theme.of(context).colorScheme.tertiary),
        onDismissed: (DismissDirection direction) async {
          await BlocProvider.of<EnvironmentsCubit>(context)
              .removeRule(environmentId: environment.name, rule: rule);
        },
        key: ValueKey(rule.runtimeType),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Icon(
                rule.accept(RuleIconVisitor(), context),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 32,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.accept(RuleNameVisitor(), context),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      rule.accept(RuleDescriptionVisitor(), context),
                    ],
                  )),
            ],
          ),
        ),
      );
}
