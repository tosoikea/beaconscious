import 'package:beaconscious/widgets/cards/card_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData leading;
  final Color? backgroundColor;

  final String title;
  final Color? titleColor;

  final String? subtitle;
  final Color? subtitleColor;

  final Widget? content;
  final Widget? caption;

  final VoidCallback? onTap;

  final Widget? action;

  const CustomCard(
      {super.key,
      required this.leading,
      required this.title,
      this.backgroundColor,
      this.titleColor,
      this.onTap,
      this.subtitle,
      this.subtitleColor,
      this.content,
      this.caption,
      this.action});

  @override
  Widget build(BuildContext context) => Card(
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Container(
              constraints: const BoxConstraints(minHeight: 80),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 20,
                            child: Icon(
                              leading,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 32,
                            ),
                          ),
                        ),
                        CardTitle(
                          title: title,
                          subtitle: subtitle,
                          titleColor: titleColor,
                          subtitleColor: subtitleColor,
                        ),
                        const Spacer(),
                        if (action != null) action!
                      ],
                    ),
                    if (content != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: content!,
                      )
                    ],
                    if (caption != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: caption!,
                      )
                    ]
                  ],
                ),
              )),
        ),
      );
}
