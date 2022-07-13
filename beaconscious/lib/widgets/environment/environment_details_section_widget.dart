import 'package:flutter/material.dart';

class EnvironmentDetailsSectionWidget extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;

  const EnvironmentDetailsSectionWidget(
      {super.key, required this.title, required this.builder});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8, right: 8),
              child: builder(context)),
        ],
      );
}
