// TODO : Remove when Material 3 support is given
import 'package:beaconscious/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget? avatar;
  final Widget label;
  final bool selected;
  final VoidCallback? onTap;

  const CustomChip(
      {super.key,
      this.avatar,
      this.onTap,
      this.selected = false,
      required this.label});

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.transparent, width: 1.5),
          color: Constants.primary80,
        ),
        child: _getContent(context),
      );
    } else {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline, width: 1.5)),
          child: _getContent(context));
    }
  }

  Widget _getContent(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6, right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: avatar!,
                )
              ],
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: label,
              )
            ],
          ),
        ),
      );
}
