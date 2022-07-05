import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/constants.dart';
import 'package:beaconscious/repositories/environments/models/environment.dart';
import 'package:beaconscious/utils/environment_utils.dart';
import 'package:beaconscious/widgets/cards/custom_card.dart';
import 'package:beaconscious/widgets/environment/environment_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnvironmentWidget extends StatefulWidget {
  final Environment environment;

  const EnvironmentWidget({Key? key, required this.environment})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnvironmentWidgetState();
}

class _EnvironmentWidgetState extends State<EnvironmentWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
          builder: (context, state) {
        if (!expanded) {
          return CustomCard(
            leading: widget.environment.icon,
            title: widget.environment.name,
            //TODO : Determine the actual day (e.g. gestern, etc.)
            subtitle:
                EnvironmentUtils.getStatus(context, widget.environment, state),
            subtitleColor: EnvironmentUtils.isActive(widget.environment, state)
                ? Constants.primary50
                : null,
            action: IconButton(
              onPressed: () => setState(() {
                expanded = true;
              }),
              icon: const Icon(Icons.arrow_drop_down_rounded),
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
                subtitle: EnvironmentUtils.getStatus(
                    context, widget.environment, state),
                subtitleColor:
                    EnvironmentUtils.isActive(widget.environment, state)
                        ? Theme.of(context).colorScheme.primary
                        : null,
                action: IconButton(
                  onPressed: () => setState(() {
                    expanded = false;
                  }),
                  icon: const Icon(Icons.arrow_drop_up_rounded),
                ),
              )
            ],
          );
        }
      });
}
