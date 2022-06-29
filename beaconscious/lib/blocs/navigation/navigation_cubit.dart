import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<AppNavigationState> {
  NavigationCubit() : super(const AppNavigationState.initial());

  /// 0. Helper functions
  /// A) Get without creation
  /// B) Create with specific creation boolean
  void _navigateToGet(
          {required AppNavigationContext context,
          String environmentId = "",
          String deviceId = ""}) =>
      emit(state.copyWith(
          context: context,
          environmentId: environmentId,
          creatingEnvironment: false,
          deviceId: deviceId,
          creatingDevice: false));

  void _navigateToCreate(
          {required AppNavigationContext context,
          String? environmentId,
          String? deviceId,
          bool creatingEnvironment = false,
          bool creatingDevice = false}) =>
      emit(state.copyWith(
          context: context,
          environmentId: environmentId,
          creatingEnvironment: creatingEnvironment,
          deviceId: deviceId,
          creatingDevice: creatingDevice));

  /// 1. Context Home
  /// A) Navigate To Home
  void toHome() => _navigateToGet(context: AppNavigationContext.home);

  /// 2. Context Environment
  /// A) Navigate To Environments
  /// B) Inspect Environment
  /// C) Create Environment
  void toEnvironments() =>
      _navigateToGet(context: AppNavigationContext.environment);
  void toEnvironment({required String environmentId}) => _navigateToGet(
      context: AppNavigationContext.environment, environmentId: environmentId);
  void createEnvironment() => _navigateToCreate(
      context: AppNavigationContext.environment, creatingEnvironment: true);

  /// 3. Context Analysis
  /// A) Navigate To Analysis
  void toAnalysis() => _navigateToGet(context: AppNavigationContext.analysis);

  /// 4. Context Detection
  /// A) Navigate To Detection
  /// B) Create Device
  void toDetection() => _navigateToGet(context: AppNavigationContext.detection);
  void createDevice() => _navigateToCreate(
      context: AppNavigationContext.detection, creatingDevice: true);

  /// Back
  /// A) Environment != null => Remove Environment
  /// B) CreateEnvironment => !CreateEnvironment
  /// C) CreateDevice=> !CreateDevice
  /// D) Context != Home => Home
  /// [D) Leave App]
  void back() {
    if (state.environmentId.isNotEmpty) {
      emit(state.copyWith(environmentId: ""));
    } else if (state.creatingEnvironment) {
      emit(state.copyWith(creatingEnvironment: false));
    } else if (state.creatingDevice) {
      emit(state.copyWith(creatingDevice: false));
    } else if (state.context != AppNavigationContext.home) {
      emit(state.copyWith(context: AppNavigationContext.home));
    }
  }
}
