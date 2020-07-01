import 'package:flutter/material.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/view/topster_box.dart';

import '../../core/test_draggables.dart';

class TopsterLayout extends StatefulWidget {
  @override
  _TopsterLayoutState createState() => _TopsterLayoutState();
}

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
        TopsterBoxesController.initialize(totalBoxes: calculateTotalBoxes());
    generateTopsterLayout();
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    setState(() {
      columns.clear();
      if (newIndex > oldIndex) newIndex -= 1;
      controller.onReorder(layoutSizes, newIndex, oldIndex);
      if (oldIndex > newIndex) rearrangeLayoutSizes(oldIndex, newIndex);
      generateTopsterLayout();
    });
  }

  void rearrangeLayoutSizes(int oldIndex, newIndex) {
    var tem = layoutSizes.removeAt(oldIndex);
    layoutSizes.insert(newIndex, tem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: <Widget>[
            Center(
              child: Container(height: 600, width: 300, color: Colors.pink
                  //  Image.network(
                  //     "https://lastfm.freetls.fastly.net/i/u/300x300/3061a718bafbccc70ac73c7dafec6a09.png",
                  //     fit: BoxFit.contain),
                  ),
            ),
            Center(
              child: Container(
                height: 600,
                width: 300,
                child: ReorderableListView(
                  onReorder: _onReorder,
                  children: columns,
                ),
              ),
            ),
          ]),
          TestDraggables()
        ],
      ),
    );
  }

  void generateGridLayout(
    int columnIndex,
  ) {
    int count = layoutSizes[columnIndex];
    Widget generatedGrid = GridView.count(
        controller: ScrollController(),
        key: UniqueKey(),
        crossAxisCount: count,
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        children: List<Widget>.generate(
            count,
            (rowIndex) => LayoutBuilder(builder: (context, constraints) {
                  return Padding(
                      padding: EdgeInsets.only(
                          top: rowPad,
                          bottom: rowPad,
                          left: columnPad,
                          right: columnPad),
                      child: TopsterBox(
                        index: calculateBoxIndex(
                          columnIndex,
                          rowIndex,
                        ),
                        controller: controller,
                        boxSize: constraints.maxWidth,
                      ));
                })));
    columns.add(generatedGrid);
  }

  void generateTopsterLayout() {
    for (int i = 0; i < layoutSizes.length; i++) {
      generateGridLayout(i);
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

  int calculateBoxIndex(int columnIndex, int rowIndex) {
    int boxIndex = layoutSizes
            .sublist(0, columnIndex)
            .fold<int>(0, (prev, element) => prev + element) +
        rowIndex;
    return boxIndex;
  }

// double calculateBoxSize(
//     BoxConstraints constraints, double rowPadding, int childIndex) {
//   double boxSize =
//       ((constraints.maxWidth - (rowPadding * childIndex)) / childIndex) -
//           rowPadding;
//   return boxSize;
// }

  int calculateTotalBoxes() {
    int totalBoxes = layoutSizes.fold<int>(
        0, (previousValue, element) => previousValue + element);
    return totalBoxes;
  }
}
