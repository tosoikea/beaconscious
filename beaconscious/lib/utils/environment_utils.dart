import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnvironmentUtils {
  static bool isActive(
    Environment environment,
    EnvironmentsState state,
  ) =>
      state.current.name == environment.name;

  static String getStatus(
      BuildContext context, Environment environment, EnvironmentsState state) {
    if (environment.disabled) {
      return AppLocalizations.of(context)!.environments_currently_disabled;
    }

    // Currently active
    if (isActive(environment, state)) {
      return AppLocalizations.of(context)!.environments_currently_active;
    } else {
      //TODO : Determine the actual day (e.g. gestern, etc.)
      return AppLocalizations.of(context)!
          .environments_previously_active("heute");
    }
  }
}
