import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final Color? titleColor;

  final String? subtitle;
  final Color? subtitleColor;

  const CardTitle(
      {super.key,
      required this.title,
      this.titleColor,
      this.subtitle,
      this.subtitleColor});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: titleColor ??
                    Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: subtitleColor),
            )
        ],
      );
}
