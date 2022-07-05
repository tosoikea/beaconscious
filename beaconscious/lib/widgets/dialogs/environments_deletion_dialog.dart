import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnvironmentsDeletionDialog extends StatefulWidget {
  final Environment environment;

  const EnvironmentsDeletionDialog({super.key, required this.environment});

  @override
  State<EnvironmentsDeletionDialog> createState() =>
      _EnvironmentsDeletionDialogState();
}

class _EnvironmentsDeletionDialogState
    extends State<EnvironmentsDeletionDialog> {
  @override
  Widget build(BuildContext context) => CustomDialog(
        title: AppLocalizations.of(context)!.delete,
        subtitle: AppLocalizations.of(context)!
            .environments_delete(widget.environment.name),
        content: Container(),
        actions: [
          TextButton(
              onPressed: () async {
                await BlocProvider.of<EnvironmentsCubit>(context)
                    .removeEnvironment(environment: widget.environment)
                    .whenComplete(() {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                });
              },
              child: Text(AppLocalizations.of(context)!.ok)),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel))
        ],
      );
}
