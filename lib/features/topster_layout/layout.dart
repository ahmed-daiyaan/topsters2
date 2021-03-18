import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';
import 'package:topsters/features/topster_layout/slide_action_widgets.dart';
import 'package:topsters/features/topster_layout/topster_grid_row.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multi_select_item/multi_select_item.dart';

import 'controller/layout_controller.dart';

class TopsterLayout extends StatefulWidget {
  final List<int> rowsBoxCount;

  const TopsterLayout({this.rowsBoxCount});
  @override
  _TopsterLayoutState createState() => _TopsterLayoutState();
}

class _TopsterLayoutState extends State<TopsterLayout> {
  LayoutController layoutController;
  MultiSelectController controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    controller.set(widget.rowsBoxCount.length);
    return ChangeNotifierProvider<LayoutController>(
      create: (context) =>
          LayoutController.initialize(widget.rowsBoxCount, context),
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Consumer<Options>(builder: (context, options, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 5),
                  //constraints: constraints,
                  padding: EdgeInsets.all(options.chartPadding),
                  decoration: BoxDecoration(
                    //shape: BoxShape.circle,
                    gradient: FlutterGradients.colorfulPeach(
                        type: GradientType.radial,
                        radius: 0.7,
                        tileMode: TileMode.decal),
                    borderRadius: BorderRadius.all(
                        Radius.circular(options.chartBorderRadius)),
                    border: Border.all(
                        color: options.chartBorderColor,
                        width: options.boxBorderSize),
                  ),
                  child: child,
                );
              }, child: Consumer<LayoutController>(
                builder: (context, layoutController, child) {
                  return ReorderableListView(
                      anchor: 0.1,
                      proxyDecorator: (widget, index, animation) {
                        return TopsterGridRow(
                          rowIndex: index,
                          rowsBoxCount: layoutController.rowsBoxCount,
                          count: layoutController.rowsBoxCount[index],
                        );
                      },
                      onReorder: layoutController.onReorder,
                      children: List<Widget>.generate(
                        layoutController.rowsBoxCount.length,
                        (index) => MultiSelectItem(
                          key: UniqueKey(),
                          isSelecting: controller.isSelecting,
                          onSelected: () {
                            controller.toggle(index);
                            debugPrint(controller.selectedIndexes.toString());
                            debugPrint(index.toString());
                          },
                          child: RowBuilder(
                            layoutController: layoutController,
                            rowIndex: index,
                            key: UniqueKey(),
                          ),
                        ),
                      ));
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  // int calculateTotalBoxes() {
  //   int totalBoxes = widget.rowsBoxCount
  //       .fold<int>(0, (previousValue, element) => previousValue + element);
  //   return totalBoxes;
  // }
}

class RowBuilder extends StatelessWidget {
  final LayoutController layoutController;
  final int rowIndex;
  // ignore: annotate_overrides
  final Key key;
  const RowBuilder({
    @required this.layoutController,
    @required this.key,
    @required this.rowIndex,
  });

  @override
  Widget build(BuildContext context) {
    final int count = layoutController.rowsBoxCount[rowIndex];
    return Slidable(
        //fastThreshold: ,
        actionExtentRatio: 0.15,
        showAllActionsThreshold: 0.2,
        key: UniqueKey(),
        actions: <Widget>[
          const RemoveAction(),
          const ReorderAction(),
          TitleAction(
            rowIndex: rowIndex,
            layoutController: layoutController,
          ),
          InsertAction(
            insertRow: layoutController.insertRow,
            rowIndex: rowIndex,
          )
        ],
        actionPane: const SlidableScrollActionPane(),
        dismissal: SlidableDismissal(
          onDismissed: (_) {
            layoutController.onRemove(rowIndex);
          },
          child: const SlidableDrawerDismissal(),
        ),
        child: Column(
          children: [
            Selector<LayoutController, Map<int, String>>(
              selector: (context, layoutController) =>
                  layoutController.titleMap,
              builder: (context, titleMap, child) {
                if (titleMap.containsKey(rowIndex)) {
                  return Text(titleMap[rowIndex]);
                } else {
                  return Container();
                }
              },
            ),
            TopsterGridRow(
              rowIndex: rowIndex,
              rowsBoxCount: layoutController.rowsBoxCount,
              count: count,
            ),
          ],
        ));
  }
}
