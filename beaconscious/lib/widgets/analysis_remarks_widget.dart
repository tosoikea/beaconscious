import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// TODO: This class has to provide actual insights
class AnalysisRemarksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.trending_up),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.8,
                    child: Text(
                      "20min länger im Home Office verbracht als letzte Woche",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.trending_down),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.8,
                    child: Text(
                      "1h weniger geschlafen als letzte Woche",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.info_outline),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.8,
                    child: Text(
                      "Diese Woche am Samstag im Home Office gewesen",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      });
}
