import 'package:beaconscious/blocs/analysis/analysis.dart';
import 'package:beaconscious/repositories/environments/models/environment.dart';
import 'package:beaconscious/repositories/logbook/models/models.dart';
import 'package:beaconscious/utils/custom_date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _CurrentAnalysisWeekDiagramData {
  final Date date;
  final int seconds;

  const _CurrentAnalysisWeekDiagramData(
      {required this.date, required this.seconds});
}

class CurrentAnalysisWeekWidget extends StatelessWidget {
  final Environment environment;

  const CurrentAnalysisWeekWidget({super.key, required this.environment});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AnalysisCubit, AnalysisState>(builder: (context, state) {
        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(
                width: 0,
              ),
              axisLine: const AxisLine(width: 0),
              labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer)),
          primaryYAxis: NumericAxis(isVisible: false),
          palette: [Theme.of(context).colorScheme.onSecondaryContainer],
          series: <CartesianSeries>[
            ColumnSeries<_CurrentAnalysisWeekDiagramData, String>(
                dataLabelSettings: DataLabelSettings(
                    // Renders the data label
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.outer,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      var analysis = data as _CurrentAnalysisWeekDiagramData;
                      var hours =
                          "${Duration(seconds: analysis.seconds).inHours}h";

                      return Text(
                        hours,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                      );
                    }),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                dataSource: (!state.currentWeek.containsKey(environment.name))
                    ? <_CurrentAnalysisWeekDiagramData>[]
                    : state.currentWeek[environment.name]!
                        .map((e) => _CurrentAnalysisWeekDiagramData(
                            date: e.date, seconds: e.seconds))
                        .toList(growable: false),
                xValueMapper: (_CurrentAnalysisWeekDiagramData data, _) =>
                    CustomDateUtils.getWeekDayShortName(
                        context, data.date.toDateTime()),
                yValueMapper: (_CurrentAnalysisWeekDiagramData data, _) =>
                    data.seconds)
          ],
        );
      });
}
