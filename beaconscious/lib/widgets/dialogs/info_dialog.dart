import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String description;

  const InfoDialog({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Icon(
                Icons.info_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
              ),
            )
          ],
        ),
        content: Text(description),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.understood))
        ],
      );
}
