import 'package:beaconscious/constants.dart';
import 'package:beaconscious/repositories/environments/models/environment.dart';
import 'package:beaconscious/widgets/cards/custom_card.dart';
import 'package:beaconscious/widgets/environment_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnvironmentWidget extends StatefulWidget {
  final Environment environment;
  final bool active;

  const EnvironmentWidget(
      {Key? key, required this.environment, required this.active})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnvironmentWidgetState();
}

class _EnvironmentWidgetState extends State<EnvironmentWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return CustomCard(
        leading: widget.environment.icon,
        title: widget.environment.name,
        //TODO : Determine the actual day (e.g. gestern, etc.)
        subtitle: (widget.active)
            ? AppLocalizations.of(context)!.environments_currently_active
            : AppLocalizations.of(context)!
                .environments_previously_active("heute"),
        subtitleColor: (widget.active) ? Constants.primary50 : null,
        action: IconButton(
          onPressed: () => setState(() {
            expanded = true;
          }),
          icon: Icon(size: 24, Icons.arrow_drop_down_rounded),
        ),
      );
    } else {
      return Stack(
        children: [
          Padding(
            // TODO : Ugly solution, but positioned is ass
            padding: const EdgeInsets.only(top: 60.0),
            child: EnvironmentDetailsWidget(
              environment: widget.environment,
            ),
          ),
          CustomCard(
            backgroundColor: Constants.primary80,
            leading: widget.environment.icon,
            title: widget.environment.name,
            //TODO : Determine the actual day (e.g. gestern, etc.)
            subtitle: (widget.active)
                ? AppLocalizations.of(context)!.environments_currently_active
                : AppLocalizations.of(context)!
                    .environments_previously_active("heute"),
            subtitleColor:
                (widget.active) ? Theme.of(context).colorScheme.primary : null,
            action: IconButton(
              onPressed: () => setState(() {
                expanded = false;
              }),
              icon: Icon(size: 24, Icons.arrow_drop_up_rounded),
            ),
          )
        ],
      );
    }
  }
}
