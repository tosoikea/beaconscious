import 'package:beaconscious/blocs/detection/detection_cubit.dart';
import 'package:beaconscious/blocs/detection/detection_state.dart';
import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/utils/detector_icon_visitor.dart';
import 'package:beaconscious/widgets/cards/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetectionPage extends BeaconsciousPage {
  const DetectionPage() : super(key: const ValueKey("DetectionPage"));

  @override
  Widget get child => Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.detection_title,
              ),
              actions: [
                IconButton(
                    onPressed: null,
                    icon: Icon(
                        color: Theme.of(context).primaryColor,
                        Icons.info_outlined))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<DetectionCubit, DetectionState>(
                builder: (context, state) => SingleChildScrollView(
                  child: Column(
                    children: state.detectors.map((e) {
                      bool isCurrent =
                          state.detected.any((element) => element.id == e.id);

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: CustomCard(
                          leading: e.accept(DetectorIconVisitor(), context),
                          title: e.name,
                          //TODO : Determine the actual day (e.g. gestern, etc.)
                          subtitle: (isCurrent)
                              ? AppLocalizations.of(context)!
                                  .detection_currently_detected
                              : AppLocalizations.of(context)!
                                  .detection_currently_not_detected,
                          subtitleColor: (isCurrent)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          action: const IconButton(
                            onPressed: null,
                            icon: Icon(size: 24, Icons.arrow_drop_down_rounded),
                          ),
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ),
            ));
      });
}
