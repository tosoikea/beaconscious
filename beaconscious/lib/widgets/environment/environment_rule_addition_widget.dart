import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/constants.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/repositories/environments/models/rules/restricted_app_usage_rule.dart';
import 'package:beaconscious/utils/rule_description_visitor.dart';
import 'package:beaconscious/utils/rule_icon_visitor.dart';
import 'package:beaconscious/utils/rule_name_visitor.dart';
import 'package:beaconscious/widgets/addition_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnvironmentRuleAdditionWidget extends StatefulWidget {
  final Environment environment;

  const EnvironmentRuleAdditionWidget({super.key, required this.environment});

  @override
  State<EnvironmentRuleAdditionWidget> createState() =>
      _EnvironmentRuleAdditionWidgetState();
}

class _EnvironmentRuleAdditionWidgetState
    extends State<EnvironmentRuleAdditionWidget> {
  bool isAdding = false;

  // TODO : Allow for edibility, retrieve rules from cubit etc.
  List<Rule> _dummyValues() => const <Rule>[
        DisabledAppNotificationsRule(
            applications: [Constants.whatsapp, Constants.instagram]),
        DoNotDisturbRule(),
        RestrictedAppUsageRule(
            applications: <String>[Constants.tiktok, Constants.twitch])
      ];

  List<Rule> _getSelectableRules(List<Rule> excluded) => _dummyValues()
      .where((outer) =>
          !excluded.any((inner) => inner.runtimeType == outer.runtimeType))
      .toList();

  @override
  Widget build(BuildContext context) {
    final selectable = _getSelectableRules(widget.environment.what);

    if (selectable.isEmpty) {
      return Container();
    }

    return AdditionWidget<Rule>(
      onSave: (rule) async => await BlocProvider.of<EnvironmentsCubit>(context)
          .addRule(environmentId: widget.environment.name, rule: rule),
      builder: (context, notifier) => _EnvironmentRuleBuildingWidget(
        selectable: selectable,
        notifier: notifier,
      ),
    );
  }
}

///
typedef RuleSavedCallback = Future<void> Function(Rule saved);

class _EnvironmentRuleBuildingWidget extends StatefulWidget {
  final ValueNotifier<Rule?> notifier;
  final List<Rule> selectable;

  const _EnvironmentRuleBuildingWidget(
      {Key? key, required this.selectable, required this.notifier})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnvironmentRuleBuildingWidgetState();
}

class _EnvironmentRuleBuildingWidgetState
    extends State<_EnvironmentRuleBuildingWidget> {
  List<DropdownMenuItem<Rule>> _getDropDownItems(BuildContext context) =>
      widget.selectable
          .map((e) => DropdownMenuItem<Rule>(
              value: e,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      e.accept(RuleIconVisitor(), context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        e.accept(RuleNameVisitor(), context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                ),
              )))
          .toList(growable: false);

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_ruleChanged);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_ruleChanged);
    super.dispose();
  }

  void _ruleChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              DropdownButtonHideUnderline(
                  child: DropdownButton2<Rule>(
                      dropdownWidth: MediaQuery.of(context).size.width * 0.85,
                      value: widget.notifier.value,
                      items: _getDropDownItems(context),
                      selectedItemBuilder: (context) => widget.selectable
                          .map((e) => Icon(
                                e.accept(RuleIconVisitor(), context),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 32,
                              ))
                          .toList(),
                      onChanged: (selected) =>
                          widget.notifier.value = selected)),
              if (widget.notifier.value != null)
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.notifier.value!
                              .accept(RuleNameVisitor(), context),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                        ),
                        widget.notifier.value!
                            .accept(RuleDescriptionVisitor(), context),
                      ],
                    ))
            ],
          ),
        ],
      );
}
