import 'package:beaconscious/blocs/detection/detection.dart';
import 'package:beaconscious/utils/detector_icon_visitor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';

class CurrentDetectionViewWidget extends StatelessWidget {
  const CurrentDetectionViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetectionCubit, DetectionState>(builder: (context, state) {
        if (state.detected.isEmpty){
          return Container();
        }


        final graph = Graph()..isTree = true;
        // TODO : Prevent collision, even though unlikely
        final userNode = Node.Id("user");
        for (var detector in state.detected) {
          graph.addEdge(userNode, Node.Id(detector.id));
        }

        var configuration = BuchheimWalkerConfiguration()
          ..siblingSeparation = (100)
          ..levelSeparation = (10)
          ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
        var builder = BuchheimWalkerAlgorithm(
            configuration, TreeEdgeRenderer(configuration));

        return InteractiveViewer(
            constrained: true,
            panEnabled: false,
            scaleEnabled: false,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: OverflowBox(
              alignment: Alignment.center,
              minWidth: 0.0,
              minHeight: 0.0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: GraphView(
                  graph: graph,
                  paint: Paint()
                    ..color = Theme.of(context).colorScheme.onSecondaryContainer
                    ..strokeWidth = 1.5
                    ..strokeCap = StrokeCap.round,
                  algorithm: builder,
                  builder: (Node node) {
                    var id = node.key!.value as String;
                    late final IconData icon;

                    if (id == "user") {
                      icon = Icons.person;
                    } else {
                      icon = state.detected
                          .firstWhere((element) => element.id == id)
                          .accept(DetectorIconVisitor(), context);
                    }

                    return Icon(
                      icon,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    );
                  }),
            ));
      });
}
