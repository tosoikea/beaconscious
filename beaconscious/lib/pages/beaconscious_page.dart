import 'package:flutter/material.dart';

abstract class BeaconsciousPage extends Page {
  Widget get child;

  const BeaconsciousPage({required LocalKey key}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      opaque: true,
      reverseTransitionDuration: Duration.zero,
      transitionDuration: Duration.zero,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
    );
  }
}
