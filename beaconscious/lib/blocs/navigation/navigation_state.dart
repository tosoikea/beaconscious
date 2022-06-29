import 'package:equatable/equatable.dart';

enum AppNavigationContext { home, environment, analysis, detection }

class AppNavigationState extends Equatable {
  /// Determines in which context of the app the user is currently navigating in.
  final AppNavigationContext context;

  /// The currently selected environment.
  final String environmentId;
  final bool creatingEnvironment;

  /// The currently selected device.
  final bool creatingDevice;

  const AppNavigationState.initial() : this._internal();

  const AppNavigationState._internal(
      {this.context = AppNavigationContext.home,
      this.environmentId = "",
      this.creatingDevice = false,
      this.creatingEnvironment = false});

  AppNavigationState copyWith(
          {AppNavigationContext? context,
          String? environmentId,
          bool? creatingEnvironment,
          String? deviceId,
          bool? creatingDevice}) =>
      AppNavigationState._internal(
          context: context ?? this.context,
          environmentId: environmentId ?? this.environmentId,
          creatingEnvironment: creatingEnvironment ?? this.creatingEnvironment,
          creatingDevice: creatingDevice ?? this.creatingDevice);

  @override
  List<Object?> get props =>
      [context, environmentId, creatingEnvironment, creatingDevice];
}
