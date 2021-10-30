import 'package:flutter/material.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import 'dialog_options.dart';

class CustomPicker extends StatelessWidget {
  const CustomPicker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GridControl>(
      create: (context) => GridControl(),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Select number of rows",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const RowCountPicker(),
          const Padding(padding: EdgeInsets.all(4)),
          const CustomGridView(),
          const Padding(
            padding: EdgeInsets.only(
              //top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: RowSteppers(),
          ),
          Consumer<GridControl>(builder: (context, controller, child) {
            return DialogOptions(
              rowsBoxCount: controller.rowTileCount,
            );
          })
        ],
      ),
    );
  }
}

class RowCountPicker extends StatelessWidget {
  const RowCountPicker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GridControl>(
      builder: (context, controller, child) {
        return NumberPicker(
            itemWidth: 50,
            textStyle: const TextStyle(fontSize: 14),
            selectedTextStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            axis: Axis.horizontal,
            minValue: 1,
            maxValue: 20,
            value: controller.rowCount,
            onChanged: (value) {
              controller.setRowCount(value);
              controller.gridController.animateTo(5,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut);
            });
      },
    );
  }
}

class GridColumn extends StatelessWidget {
  final int index;
  final Widget box = Container(color: const Color(0xFF050505));
  GridColumn(this.index);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 3)),
        Selector<GridControl, int>(
            selector: (context, controller) => controller.rowTileCount[index],
            builder: (context, tilesCount, child) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: tilesCount,
                itemBuilder: (context, index) {
                  return box;
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 3, crossAxisCount: tilesCount),
              );
            }),
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomGridView extends StatelessWidget {
  const CustomGridView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 240,
      child: Selector<GridControl, int>(
          selector: (context, controller) => controller.rowCount,
          builder: (context, rowCount, child) {
            return Scrollbar(
                controller: Provider.of<GridControl>(context).gridController,
                isAlwaysShown: true,
                thickness: 3,
                hoverThickness: 6,
                radius: const Radius.circular(0),
                showTrackOnHover: true,
                child: Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                    child: ListView.builder(
                        itemCount: rowCount,
                        controller:
                            Provider.of<GridControl>(context).gridController,
                        itemBuilder: (context, index) {
                          return GridColumn(index);
                        })));
          }),
    );
  }
}

class RowSteppers extends StatelessWidget {
  const RowSteppers({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 303,
      width: 220,
      child: Consumer<GridControl>(builder: (context, controller, child) {
        return Padding(
            padding: const EdgeInsets.only(left: 11.0, right: 11.0, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: controller.rowCount > 9 ? 2 : 1,
                  child: RowList(
                    controller: controller,
                    rowNumber: 1,
                  ),
                ),
                if (controller.rowCount > 10)
                  Flexible(
                      flex: 2,
                      child: RowList(
                        controller: controller,
                        rowNumber: 2,
                      ))
                else
                  Container(),
              ],
            ));
      }),
    );
  }
}

class RowList extends StatelessWidget {
  final GridControl controller;
  final int rowNumber;
  const RowList({
    Key key,
    this.controller,
    this.rowNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 30,
      itemCount: rowNumber == 1
          ? controller.rowCount > 10
              ? 10
              : controller.rowCount
          : controller.rowCount - 10,
      itemBuilder: (context, index) {
        if (rowNumber == 2) index += 10;
        return Row(
          children: [
            Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF050505),
                  // borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Row ${index + 1}",
                  style:
                      const TextStyle(color: Color(0xFFEBEBEB), fontSize: 14),
                )),
            Container(
              height: 30,
              //width: 10,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF050505)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 15,
                    child: TextButton(
                      // style: ButtonStyle(
                      //     minimumSize: MaterialStateProperty.resolveWith<Size>(
                      //         (states) => const Size(50, 50))),
                      onPressed: () {
                        controller.decrementRowTileCount(index);
                      },
                      child: const Text("-",
                          style: TextStyle(
                              color: Color(0xFF050505), fontSize: 12)),
                    ),
                  ),
                  Text(controller.rowTileCount[index].toString()),
                  SizedBox(
                    width: 15,
                    child: TextButton(
                      onPressed: () {
                        controller.incrementRowTileCount(index);
                      },
                      child: const Text(
                        "+",
                        style: TextStyle(color: Color(0xFF050505)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class GridControl extends ChangeNotifier {
  int rowCount = 5;
  List<int> rowTileCount = List<int>.generate(5, (index) => 5);
  ScrollController gridController = ScrollController();

  void setRowCount(int value) {
    if (value > rowCount) {
      for (int i = 0; i < value - rowCount; i++) {
        rowTileCount.add(5);
      }
    } else {
      for (int i = 0; i < rowCount - value; i++) {
        rowTileCount.removeLast();
      }
    }
    rowCount = value;

    // gridController.jumpTo(1000);

    notifyListeners();
  }

  void setRowTiles(num value, int index) {
    rowTileCount[index] = value.toInt();
  }

  void decrementRowTileCount(int index) {
    if (rowTileCount[index] > 1) {
      rowTileCount[index] -= 1;
      notifyListeners();
    }
  }

  void incrementRowTileCount(int index) {
    if (rowTileCount[index] < 20) {
      rowTileCount[index] += 1;
      notifyListeners();
    }
  }
}
