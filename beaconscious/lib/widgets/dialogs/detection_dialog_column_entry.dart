import 'package:flutter/material.dart';

class DetectionDialogColumnEntry extends StatelessWidget {
  final VoidCallback onTap;
  final Widget leading;
  final List<Widget> children;

  const DetectionDialogColumnEntry(
      {super.key,
      required this.onTap,
      required this.leading,
      required this.children});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(child: leading),
            ),
            ...children.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: e,
                ))
          ],
        ),
      );
}
