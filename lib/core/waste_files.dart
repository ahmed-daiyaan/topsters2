// double calculateBoxSize(
//     BoxConstraints constraints, double rowPadding, int childIndex) {
//   double boxSize =
//       ((constraints.maxWidth - (rowPadding * childIndex)) / childIndex) -
//           rowPadding;
//   return boxSize;
// }

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

// return LayoutBuilder(builder: (context, constraints) {
//   return Padding(
//       padding: EdgeInsets.only(
//           top: rowPad,
//           bottom: rowPad,
//           left: columnPad,
//           right: columnPad),
//       child: TopsterBox(
//         index: calculateBoxIndex(
//           columnIndex,
//           index,
//         ),
//         controller: controller,
//         boxSize: constraints.maxWidth,
//       ));
// });

//addAutomaticKeepAlives: false,
// children: List<Widget>.generate(
//     count,
//     (rowIndex) => LayoutBuilder(builder: (context, constraints) {
//           return Padding(
//               padding: EdgeInsets.only(
//                   top: rowPad,
//                   bottom: rowPad,
//                   left: columnPad,
//                   right: columnPad),
//               child: TopsterBox(
//                 index: calculateBoxIndex(
//                   columnIndex,
//                   rowIndex,
//                 ),
//                 controller: controller,
//                 boxSize: constraints.maxWidth,
//               ));
//         })));
// Widget generatedGrid = GridView.count(
//     controller: ScrollController(),
//     key: UniqueKey(),
//     crossAxisCount: count,
//     shrinkWrap: true,
//     addAutomaticKeepAlives: false,
//     children: List<Widget>.generate(
//         count,
//         (rowIndex) => LayoutBuilder(builder: (context, constraints) {
//               return Padding(
//                   padding: EdgeInsets.only(
//                       top: rowPad,
//                       bottom: rowPad,
//                       left: columnPad,
//                       right: columnPad),
//                   child: TopsterBox(
//                     index: calculateBoxIndex(
//                       columnIndex,
//                       rowIndex,
//                     ),
//                     controller: controller,
//                     boxSize: constraints.maxWidth,
//                   ));
//             })))
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
// import 'package:topsters/features/topster_layout/view/topster_box.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class TopsterLayout extends StatefulWidget {
//   final double rowPad;
//   final double columnPad;
//   TopsterLayout({this.rowPad, this.columnPad});
//   @override
//   _TopsterLayoutState createState() => _TopsterLayoutState();
// }

// class _TopsterLayoutState extends State<TopsterLayout> {
//   final List<int> layoutSizes = [2, 3, 5];

//   BehaviorSubject<int> insertRowStream = BehaviorSubject<int>();
//   List<Widget> rows = List<Widget>();
//   TopsterBoxesController controller;
//   @override
//   void initState() {
//     super.initState();
//     controller =
//         TopsterBoxesController.initialize(totalBoxes: calculateTotalBoxes());
//     generateTopsterLayout();
//   }

//   @override
//   void dispose() {
//     insertRowStream.close();
//     super.dispose();
//   }

//   void _onReorder(int oldIndex, int newIndex) {
//     if (oldIndex == newIndex) return;
//     setState(() {
//       rows.clear();
//       if (newIndex > oldIndex) newIndex -= 1;
//       controller.onReorder(layoutSizes, newIndex, oldIndex);
//       if (oldIndex > newIndex) rearrangeLayoutSizes(oldIndex, newIndex);
//       generateTopsterLayout();
//     });
//   }

//   void insertRow(int rowIndex, int boxCount) {
//     print(rowIndex);
//     setState(() {
//       rows.clear();
//       controller.insertRow(rowIndex, boxCount, layoutSizes);
//       layoutSizes.insert(rowIndex, boxCount);
//       generateTopsterLayout();
//     });
//   }

//   void rearrangeLayoutSizes(int oldIndex, int newIndex) {
//     var row = layoutSizes.removeAt(oldIndex);
//     layoutSizes.insert(newIndex, row);
//   }

//   void onRemove(int index) {
//     setState(() {
//       rows.clear();
//       controller.removeRow(index, layoutSizes);
//       layoutSizes.removeAt(index);
//       generateTopsterLayout();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             return Container(
//               child: ReorderableListView(
//                 onReorder: _onReorder,
//                 children: rows,
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   void generateGridLayout(
//     int columnIndex,
//   ) {
//     int count = layoutSizes[columnIndex];
//     Widget generatedGrid = Slidable(
//       closeOnScroll: false,
//       actions: <Widget>[
//         IconSlideAction(
//           caption: 'Remove',
//           color: Colors.red,
//           icon: Icons.cancel,
//         ),
//         IconSlideAction(
//           caption: 'Reorder',
//           color: Colors.pink,
//           icon: Icons.compare_arrows,
//         ),
//         IconSlideAction(
//           closeOnTap: false,
//           iconWidget: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Flexible(
//                 child: FittedBox(
//                     child: StreamBuilder<int>(
//                         stream: insertRowStream,
//                         initialData: 1,
//                         builder: (context, snapshot) {
//                           return DropdownButton<int>(
//                               value: snapshot.data,
//                               //icon: Icon(Icons.add_box),
//                               items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//                                   .map<DropdownMenuItem<int>>((int value) {
//                                 return DropdownMenuItem<int>(
//                                   child: Text('$value'),
//                                   value: value,
//                                 );
//                               }).toList(),
//                               onChanged: (newValue) {
//                                 insertRowStream.add(newValue);
//                               });
//                         })),
//               ),
//               Flexible(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Flexible(
//                         child: FittedBox(
//                             child: Center(
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_upward),
//                         onPressed: () {
//                           insertRowStream.value != null
//                               ? insertRow(columnIndex, insertRowStream.value)
//                               : insertRow(columnIndex, 1);
//                         },
//                       ),
//                     ))),
//                     Flexible(
//                         child: FittedBox(
//                             child: Center(
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_downward),
//                         onPressed: () {
//                           insertRowStream.value != null
//                               ? insertRow(
//                                   columnIndex + 1, insertRowStream.value)
//                               : insertRow(columnIndex, 1);
//                         },
//                       ),
//                     ))),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//       dismissal: SlidableDismissal(
//         child: SlidableDrawerDismissal(),
//         onDismissed: (_) {
//           onRemove(columnIndex);
//         },
//       ),

//       key: UniqueKey(),
//       actionPane: SlidableScrollActionPane(),

//       child: GridView.custom(
//           controller: ScrollController(),
//           shrinkWrap: true,
//           dragStartBehavior: DragStartBehavior.down,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: count,
//           ),
//           childrenDelegate: SliverChildListDelegate.fixed(List<Widget>.generate(
//               count,
//               (rowIndex) => LayoutBuilder(builder: (context, constraints) {
//                     //print(constraints);
//                     return Padding(
//                         padding: EdgeInsets.only(
//                             top: widget.rowPad,
//                             bottom: widget.rowPad,
//                             left: widget.columnPad,
//                             right: widget.columnPad),
//                         child: TopsterBox(
//                           index: calculateBoxIndex(
//                             columnIndex,
//                             rowIndex,
//                           ),
//                           controller: controller,
//                           boxSize: constraints.maxWidth,
//                         ));
//                   })))),

//       // return LayoutBuilder(builder: (context, constraints) {
//       //   return Padding(
//       //       padding: EdgeInsets.only(
//       //           top: rowPad,
//       //           bottom: rowPad,
//       //           left: columnPad,
//       //           right: columnPad),
//       //       child: TopsterBox(
//       //         index: calculateBoxIndex(
//       //           columnIndex,
//       //           index,
//       //         ),
//       //         controller: controller,
//       //         boxSize: constraints.maxWidth,
//       //       ));
//       // });
//     );
//     //addAutomaticKeepAlives: false,
//     // children: List<Widget>.generate(
//     //     count,
//     //     (rowIndex) => LayoutBuilder(builder: (context, constraints) {
//     //           return Padding(
//     //               padding: EdgeInsets.only(
//     //                   top: rowPad,
//     //                   bottom: rowPad,
//     //                   left: columnPad,
//     //                   right: columnPad),
//     //               child: TopsterBox(
//     //                 index: calculateBoxIndex(
//     //                   columnIndex,
//     //                   rowIndex,
//     //                 ),
//     //                 controller: controller,
//     //                 boxSize: constraints.maxWidth,
//     //               ));
//     //         })));
//     // Widget generatedGrid = GridView.count(
//     //     controller: ScrollController(),
//     //     key: UniqueKey(),
//     //     crossAxisCount: count,
//     //     shrinkWrap: true,
//     //     addAutomaticKeepAlives: false,
//     //     children: List<Widget>.generate(
//     //         count,
//     //         (rowIndex) => LayoutBuilder(builder: (context, constraints) {
//     //               return Padding(
//     //                   padding: EdgeInsets.only(
//     //                       top: rowPad,
//     //                       bottom: rowPad,
//     //                       left: columnPad,
//     //                       right: columnPad),
//     //                   child: TopsterBox(
//     //                     index: calculateBoxIndex(
//     //                       columnIndex,
//     //                       rowIndex,
//     //                     ),
//     //                     controller: controller,
//     //                     boxSize: constraints.maxWidth,
//     //                   ));
//     //             })));
//     rows.add(generatedGrid);
//   }

//   void generateTopsterLayout() {
//     for (int i = 0; i < layoutSizes.length; i++) {
//       generateGridLayout(i);
//     }
//   }

// // List<Widget> generateTopsterLayout(List<int> topsterLayoutBoxSizes,
// //     double columnPadding, double rowPadding, BoxConstraints constraints) {
// //   final TopsterBoxesController controller = TopsterBoxesController.initialize(
// //       calculateTotalBoxes(topsterLayoutBoxSizes));
// //   int childIndex;
// //   int nextIndex;
// //   double boxSize;
// //   List<Widget> generatedLayout =
// //       List<Widget>.generate(topsterLayoutBoxSizes.length, (columnIndex) {
// //     childIndex = topsterLayoutBoxSizes[columnIndex];
// //     boxSize = calculateBoxSize(constraints, rowPadding, childIndex);
// //     return Padding(
// //       padding: EdgeInsets.only(top: columnPadding, bottom: columnPadding),
// //       child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: List<Widget>.generate(childIndex, (rowIndex) {
// //             nextIndex =
// //                 calculateBoxIndex(topsterLayoutBoxSizes, columnIndex, rowIndex);
// //             return TopsterBox(
// //                 boxSize: boxSize, index: nextIndex, controller: controller);
// //           })),
// //     );
// //   });
// //   return (generatedLayout);
// // }

//   int calculateBoxIndex(int columnIndex, int rowIndex) {
//     int boxIndex = layoutSizes
//             .sublist(0, columnIndex)
//             .fold<int>(0, (prev, element) => prev + element) +
//         rowIndex;
//     return boxIndex;
//   }

// // double calculateBoxSize(
// //     BoxConstraints constraints, double rowPadding, int childIndex) {
// //   double boxSize =
// //       ((constraints.maxWidth - (rowPadding * childIndex)) / childIndex) -
// //           rowPadding;
// //   return boxSize;
// // }

//   int calculateTotalBoxes() {
//     int totalBoxes = layoutSizes.fold<int>(
//         0, (previousValue, element) => previousValue + element);
//     return totalBoxes;
//   }
// }
