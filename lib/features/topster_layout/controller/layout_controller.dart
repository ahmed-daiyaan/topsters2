import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';

class LayoutController extends ChangeNotifier {
  Map<int, String> titleMap = <int, String>{};
  final BuildContext context;
  List<int> rowsBoxCount;

  LayoutController({
    this.context,
    this.rowsBoxCount,
  });

  factory LayoutController.initialize(
      List<int> rowsBoxCount, BuildContext context) {
    return LayoutController(
      rowsBoxCount: rowsBoxCount,
      context: context,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    // ignore: parameter_assignments
    if (newIndex > oldIndex) newIndex -= 1;
    Provider.of<TopsterBoxesController>(context, listen: false)
        .onReorder(rowsBoxCount, newIndex, oldIndex);
    if (oldIndex > newIndex) rearrangeRowsBoxCount(oldIndex, newIndex);

    //rearrangeTitles(oldIndex, newIndex);
    notifyListeners();
  }

  // void rearrangeTitles(int oldIndex, int newIndex) {
  //   if (!titleBoxStream.hasValue) titleBoxStream.add({});
  //   var temp = titleBoxStream.value;
  //   if (titleBoxStream.value.containsKey(newIndex) &&
  //       titleBoxStream.value.containsKey(oldIndex)) {
  //     String t = temp[oldIndex];
  //     temp[oldIndex] = temp[newIndex];
  //     temp[newIndex] = t;
  //     titleBoxStream.add(temp);
  //   } else if (titleBoxStream.value.containsKey(newIndex) ||
  //       titleBoxStream.value.containsKey(oldIndex)) {
  //     if (titleBoxStream.value.containsKey(newIndex)) {
  //       temp[oldIndex] = temp[newIndex];
  //       temp.remove(newIndex);
  //       titleBoxStream.add(temp);
  //     } else {
  //       temp[newIndex] = temp[oldIndex];
  //       temp.remove(oldIndex);
  //       titleBoxStream.add(temp);
  //     }
  //   }
  // }

  void insertTitle(String enteredTitle, int index) {
    titleMap[index] = enteredTitle;
    notifyListeners();
  }

  void insertRow(int rowIndex, int boxCount) {
    Provider.of<TopsterBoxesController>(context, listen: false)
        .insertRow(rowIndex, boxCount, rowsBoxCount);
    rowsBoxCount.insert(rowIndex, boxCount);
    notifyListeners();
  }

  void rearrangeRowsBoxCount(int oldIndex, int newIndex) {
    final row = rowsBoxCount.removeAt(oldIndex);
    rowsBoxCount.insert(newIndex, row);
    notifyListeners();
  }

  void onRemove(int index) {
    Provider.of<TopsterBoxesController>(context, listen: false)
        .removeRow(index, rowsBoxCount);
    rowsBoxCount.removeAt(index);
    notifyListeners();
  }

  int calculateTotalBoxes() {
    final int totalBoxes = rowsBoxCount.fold<int>(
        0, (previousValue, element) => previousValue + element);
    return totalBoxes;
  }
}
