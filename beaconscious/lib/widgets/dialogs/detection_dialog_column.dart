import 'package:flutter/material.dart';

class DetectionDialogColumn extends StatelessWidget {
  final List<Widget> children;

  const DetectionDialogColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) => Column(
        children: children
            .map((e) => <Widget>[
                  e,
                  const Divider(
                    thickness: 2,
                  )
                ])
            .fold<List<Widget>>(
                <Widget>[],
                (previousValue, element) =>
                    previousValue..addAll(element)).toList(growable: false),
      );
}
