import 'dart:async';

import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:beaconscious/navigation/routes/routes.dart';
import 'package:beaconscious/pages/analysis_page.dart';
import 'package:beaconscious/pages/detection_page.dart';
import 'package:beaconscious/pages/environment_page.dart';
import 'package:beaconscious/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeaconsciousRouterDelegate extends RouterDelegate<RoutePath>
    with PopNavigatorRouterDelegateMixin<RoutePath>, ChangeNotifier {
  final NavigationCubit _navigationCubit;
  late final StreamSubscription _navigationSubscription;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  BeaconsciousRouterDelegate({required NavigationCubit navigationCubit})
      : _navigationCubit = navigationCubit,
        navigatorKey = GlobalKey<NavigatorState>() {
    _navigationSubscription =
        _navigationCubit.stream.listen(_onAppNavigationStateChanged);
  }

  void _onAppNavigationStateChanged(AppNavigationState state) {
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NavigationCubit, AppNavigationState>(
          builder: (context, state) => Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: Navigator(
                    key: navigatorKey,
                    pages: [
                      const HomePage(),
                      if (state.context ==
                          AppNavigationContext.environment) ...[
                        const EnvironmentPage()
                        // TODO : Creation Screen
                        // TODO : Detail Screen
                      ] else if (state.context ==
                          AppNavigationContext.analysis) ...[
                        const AnalysisPage()
                      ] else if (state.context ==
                          AppNavigationContext.detection) ...[
                        const DetectionPage()
                      ]
                    ],
                    onPopPage: (route, result) {
                      if (!route.didPop(result)) {
                        return false;
                      }

                      _navigationCubit.back();

                      return true;
                    },
                  ),
                ),
              ));

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    /// 1. Context Home
    /// A) Navigate To Home
    if (configuration is HomeRoutePath) {
      _navigationCubit.toHome();
    }

    /// 2. Context Environment
    /// A) Navigate To Environments
    /// B) Create Environment
    else if (configuration is EnvironmentRoutePath) {
      if (configuration is! EnvironmentCreationRoute) {
        _navigationCubit.toEnvironments();
      } else {
        _navigationCubit.createEnvironment();
      }
    }

    /// 3. Context Analysis
    /// A) Navigate To Analysis
    else if (configuration is AnalysisRoutePath) {
      _navigationCubit.toAnalysis();
    }

    /// 4. Context Detection
    /// A) Navigate To Detection
    /// B) Create Device
    else if (configuration is DetectionRoutePath) {
      if (configuration is! DetectionCreationRoutePath) {
        _navigationCubit.toDetection();
      } else {
        _navigationCubit.createDevice();
      }
    }
  }

  @override
  void dispose() {
    _navigationSubscription.cancel();
    super.dispose();
  }
}
