import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/view/topster_box.dart';

import '../../core/test_draggables.dart';
import 'package:reorderables/reorderables.dart';

class TopsterLayout extends StatefulWidget {
  @override
  _TopsterLayoutState createState() => _TopsterLayoutState();
}

BehaviorSubject<int> s = new BehaviorSubject<int>();

class _TopsterLayoutState extends State<TopsterLayout> {
  final List<int> layoutSizes = [5, 6, 3, 3, 3, 2];

  final double rowPad = 1.5;

  final double columnPad = 1.5;
  List<Widget> columns = List<Widget>();
  TopsterBoxesController controller;
  @override
  void initState() {
    super.initState();
    controller =
        TopsterBoxesController.initialize(calculateTotalBoxes(layoutSizes));

    for (int i = 0; i < layoutSizes.length; i++) {
      generateGridLayout(layoutSizes, controller, i, rowPad, columnPad);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      print('oldindex:$oldIndex');
      print('newindex:$newIndex');

      columns.clear();
      print(layoutSizes);

      controller.onReorder(layoutSizes, newIndex, oldIndex);
      // var tem = layoutSizes.removeAt(oldIndex);
      // layoutSizes.insert(newIndex, tem);
      for (int i = 0; i < layoutSizes.length; i++) {
        generateGridLayout(layoutSizes, controller, i, rowPad, columnPad);
      }
      // print('newlayoutsizes $layoutSizes');
      // Widget column = columns.removeAt(oldIndex);
      // columns.insert(newIndex, column);
      s.sink.add(1);
    });
  }
  // // columns.clear();
  // int removedRow = layoutSizes.removeAt(oldIndex);
  // layoutSizes.insert(newIndex, removedRow);
  // // for (int i = 0; i < layoutSizes.length; i++) {
  // //   generateGridLayout(layoutSizes, controller, i, rowPad, columnPad);
  // // }
  // controller.onReorder(layoutSizes, oldIndex, newIndex);
  // // });

  @override
  void dispose() {
    s.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("hi");
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<Object>(
                stream: s,
                builder: (context, snapshot) {
                  return ReorderableListView(
                    //scrollController: ScrollController(),
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    onReorder: _onReorder,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: columns,
                    // buildDraggableFeedback: (context, constraints, child) =>
                    //     Container(color: Colors.black, height: 100, width: 100),
                  );
                }),
          ),
          TestDraggables()
        ],
      ),
    );
  }

  Widget generateGridLayout(
      List<int> topsterLayoutBoxSizes,
      TopsterBoxesController controller,
      int columnIndex,
      double rowPad,
      double columnPad) {
    int count = topsterLayoutBoxSizes[columnIndex];
    var generatedGrid = GridView.count(
        controller: ScrollController(),
        key: UniqueKey(),
        crossAxisCount: count,
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        children: List<Widget>.generate(
            count,
            (rowIndex) => LayoutBuilder(builder: (context, constraints) {
                  // print(constraints);
                  return Padding(
                      padding: EdgeInsets.only(
                          top: rowPad,
                          bottom: rowPad,
                          left: columnPad,
                          right: columnPad),
                      child: TopsterBox(
                        index: calculateBoxIndex(
                          topsterLayoutBoxSizes,
                          columnIndex,
                          rowIndex,
                        ),
                        controller: controller,
                        boxSize: constraints.maxWidth,
                      ));
                })));
    columns.add(generatedGrid);
    return generatedGrid;
  }
}

// List<Widget> generateTopsterLayout(List<int> topsterLayoutBoxSizes,
//     double columnPadding, double rowPadding, BoxConstraints constraints) {
//   final TopsterBoxesController controller = TopsterBoxesController.initialize(
//       calculateTotalBoxes(topsterLayoutBoxSizes));
//   int childIndex;
//   int nextIndex;
//   double boxSize;
//   List<Widget> generatedLayout =
//       List<Widget>.generate(topsterLayoutBoxSizes.length, (columnIndex) {
//     childIndex = topsterLayoutBoxSizes[columnIndex];
//     boxSize = calculateBoxSize(constraints, rowPadding, childIndex);
//     return Padding(
//       padding: EdgeInsets.only(top: columnPadding, bottom: columnPadding),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List<Widget>.generate(childIndex, (rowIndex) {
//             nextIndex =
//                 calculateBoxIndex(topsterLayoutBoxSizes, columnIndex, rowIndex);
//             return TopsterBox(
//                 boxSize: boxSize, index: nextIndex, controller: controller);
//           })),
//     );
//   });
//   return (generatedLayout);
// }

int calculateBoxIndex(
    List<int> topsterLayoutBoxSizes, int columnIndex, int rowIndex) {
  int boxIndex = topsterLayoutBoxSizes
          .sublist(0, columnIndex)
          .fold<int>(0, (prev, element) => prev + element) +
      rowIndex;
  //print(boxIndex);
  return boxIndex;
}

// double calculateBoxSize(
//     BoxConstraints constraints, double rowPadding, int childIndex) {
//   double boxSize =
//       ((constraints.maxWidth - (rowPadding * childIndex)) / childIndex) -
//           rowPadding;
//   return boxSize;
// }

int calculateTotalBoxes(List<int> layoutList) {
  int totalBoxes = layoutList.fold<int>(
      0, (previousValue, element) => previousValue + element);
  return totalBoxes;
}
