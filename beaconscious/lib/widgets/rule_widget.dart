import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/utils/rule_description_visitor.dart';
import 'package:beaconscious/utils/rule_icon_visitor.dart';
import 'package:beaconscious/utils/rule_name_visitor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RuleWidget extends StatelessWidget {
  final Rule rule;

  const RuleWidget({super.key, required this.rule});

  @override
  Widget build(BuildContext context) => Padding(
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
      );
}
