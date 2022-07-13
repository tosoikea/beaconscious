import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final List<Widget> actions;

  const CustomDialog(
      {super.key,
      required this.title,
      this.subtitle,
      required this.content,
      required this.actions});

  @override
  // TODO : Styling
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(title),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [if (subtitle != null) Text(subtitle!), content],
            ),
          ),
        ),
        actions: actions,
      );
}
