import 'package:beaconscious/custom_icons.dart';
import 'package:beaconscious/pages/beaconscious_page.dart';
import 'package:beaconscious/widgets/analysis_diagram_widget.dart';
import 'package:beaconscious/widgets/analysis_remarks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AnalysisRange { day, week, month }

class AnalysisPage extends BeaconsciousPage {
  const AnalysisPage() : super(key: const ValueKey("AnalysisPage"));

  @override
  Widget get child => Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _AnalysisPageWidget(),
        );
      });
}

class _AnalysisPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalysisPageWidgetState();
}

class _AnalysisPageWidgetState extends State<_AnalysisPageWidget>
    with SingleTickerProviderStateMixin {
  final today = const Icon(CustomIcons.calendarToday);
  final week = const Icon(CustomIcons.calendarWeek);
  final month = const Icon(CustomIcons.calendarMonth);

  int selected = 1;
  TabController? _tabController;

  TextStyle _getStyle(BuildContext context, bool selected) => TextStyle(
        // ON SURFACE
        color: (selected)
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Oxygen',
      );

  Widget _highlight(BuildContext context, Widget child) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: child,
        ),
      );

  AnalysisRange _convertToRange() {
    switch (selected) {
      case 0:
        return AnalysisRange.day;
      case 1:
        return AnalysisRange.week;
      case 2:
        // TODO : implement month
        return AnalysisRange.week;
      default:
        return AnalysisRange.week;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    // Update internal state after tab changed
    _tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.analysis_title,
        ),
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(
                  color: Theme.of(context).primaryColor, Icons.info_outlined))
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(
              icon: _tabController!.index == 0
                  ? _highlight(context, today)
                  : today,
              child: Text(
                AppLocalizations.of(context)!.day,
                style: _getStyle(context, _tabController!.index == 0),
              )),
          Tab(
              icon:
                  _tabController!.index == 1 ? _highlight(context, week) : week,
              child: Text(
                AppLocalizations.of(context)!.week,
                style: _getStyle(context, _tabController!.index == 1),
              )),
          Tab(
              icon: _tabController!.index == 2
                  ? _highlight(context, month)
                  : month,
              child: Text(
                AppLocalizations.of(context)!.month,
                style: _getStyle(context, _tabController!.index == 2),
              ))
        ],
      ),
      body: Column(
        children: [
          AnalysisDiagramWidget(
            range: _convertToRange(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AnalysisRemarksWidget(),
          )
        ],
      ));

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}
