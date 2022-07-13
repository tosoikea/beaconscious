import 'package:beaconscious/blocs/analysis/analysis.dart';
import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/pages/analysis_page.dart';
import 'package:beaconscious/repositories/environments/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _AnalysisDiagramData {
  final IconData icon;
  final String name;
  final int seconds;

  const _AnalysisDiagramData(
      {required this.icon, required this.name, required this.seconds});
}

class AnalysisDiagramWidget extends StatelessWidget {
  final AnalysisRange range;

  const AnalysisDiagramWidget({super.key, required this.range});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EnvironmentsCubit, EnvironmentsState>(
          builder: (context, eState) {
        return BlocBuilder<AnalysisCubit, AnalysisState>(
            builder: (context, aState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back_ios_rounded),
                SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<_AnalysisDiagramData, Icon>(
                        dataLabelSettings: DataLabelSettings(
                            // Renders the data label
                            isVisible: true,
                            builder: (dynamic data,
                                dynamic point,
                                dynamic series,
                                int pointIndex,
                                int seriesIndex) {
                              var chartData = data as _AnalysisDiagramData;
                              return Icon(
                                chartData.icon,
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            }),
                        radius: '85%',
                        innerRadius: '60%',
                        dataSource: aState.currentWeek.entries
                            .map((e) => _AnalysisDiagramData(
                                icon: eState.environments
                                    .firstWhere(
                                        (element) => element.name == e.key,
                                        orElse: () => Environment.empty)
                                    .icon,
                                name: e.key,
                                seconds: e.value.map((e) => e.seconds).reduce(
                                    (value, element) => value + element)))
                            .toList(growable: false),
                        xValueMapper: (_AnalysisDiagramData data, _) =>
                            Icon(data.icon),
                        yValueMapper: (_AnalysisDiagramData data, _) =>
                            data.seconds)
                  ],
                ),
                const Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          );
        });
      });
}
