import 'package:beaconscious/blocs/analysis/analysis.dart';
import 'package:beaconscious/blocs/detection/detection_cubit.dart';
import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/blocs/navigation/navigation.dart';
import 'package:beaconscious/navigation/beaconscious_route_information_parser.dart';
import 'package:beaconscious/navigation/beaconscious_router_delegate.dart';
import 'package:beaconscious/repositories/detection/detection_repository.dart';
import 'package:beaconscious/repositories/detection/firebase_detection_repository.dart';
import 'package:beaconscious/repositories/environments/environments_repository.dart';
import 'package:beaconscious/repositories/environments/local_environments_repository.dart';
import 'package:beaconscious/repositories/logbook/dummy_logbook_repository.dart';
import 'package:beaconscious/repositories/logbook/logbook_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BeaconsciousApp extends StatelessWidget {
  const BeaconsciousApp();

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DetectionRepository>(
                create: (_) => FirebaseDetectionRepository()),
            RepositoryProvider<EnvironmentsRepository>(
                create: (_) => LocalEnvironmentsRepository()),
            RepositoryProvider<LogbookRepository>(
                create: (_) => DummyLogbookRepository()),
          ],
          child: MultiBlocProvider(providers: [
            BlocProvider(
              lazy: false,
              create: (_) => NavigationCubit(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => AnalysisCubit(
                  RepositoryProvider.of<LogbookRepository>(context),
                  BlocProvider.of<NavigationCubit>(context)),
            ),
            BlocProvider(
                lazy: false,
                create: (context) => DetectionCubit(
                    RepositoryProvider.of<DetectionRepository>(context))),
            BlocProvider(
                lazy: false,
                create: (context) => EnvironmentsCubit(
                    RepositoryProvider.of<EnvironmentsRepository>(context),
                    RepositoryProvider.of<DetectionRepository>(context)))
          ], child: const _BeaconsciousAppInternal()));
}

class _BeaconsciousAppInternal extends StatelessWidget {
  const _BeaconsciousAppInternal();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFEFBFF),
        statusBarIconBrightness: Brightness.dark));

    return MaterialApp.router(
      title: "BeaConscious",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
              bodyMedium: TextStyle(fontFamily: 'Oxygen', fontSize: 14),
              bodySmall: TextStyle(fontFamily: 'Oxygen', fontSize: 12),
              bodyLarge: TextStyle(fontFamily: 'Oxygen', fontSize: 16)),
          appBarTheme: const AppBarTheme(
              // SURFACE
              titleTextStyle: TextStyle(
            // ON SURFACE
            color: Color(0xFF1B1B1F),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oxygen',
          )),
          useMaterial3: true,
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFF376FDA),
              onPrimary: Color(0xFFFFFFFF),
              primaryContainer: Color(0xFFDDE1FF),
              onPrimaryContainer: Color(0xFF00105B),
              secondary: Color(0xFF5A5D72),
              onSecondary: Color(0xFFFFFFFF),
              secondaryContainer: Color(0xFFDFE1FA),
              onSecondaryContainer: Color(0xFF0B1B7B),
              tertiary: Color(0xFF76546E),
              onTertiary: Color(0xFFFFFFFF),
              tertiaryContainer: Color(0xFFFFD6F4),
              onTertiaryContainer: Color(0xFF2C1228),
              error: Color(0xFFF27357),
              onError: Color(0xFFFFFFFF),
              background: Color(0xFFFEFBFF),
              onBackground: Color(0xFF1B1B1F),
              surface: Color(0xFFFEFBFF),
              onSurface: Color(0xFF1B1B1F),
              surfaceVariant: Color(0xFFE9EDFF),
              onSurfaceVariant: Color(0xFF373C6B),
              outline: Color(0xFF7A7ABF))),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      routeInformationParser: BeaconsciousRouteInformationParser(),
      routerDelegate: BeaconsciousRouterDelegate(
          navigationCubit: BlocProvider.of<NavigationCubit>(context)),
    );
  }
}
