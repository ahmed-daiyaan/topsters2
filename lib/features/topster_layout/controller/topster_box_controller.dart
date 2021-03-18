import 'package:flutter/widgets.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

class TopsterBoxesController extends ChangeNotifier {
  final List<TopsterBoxData> topsterStore;
  TopsterBoxesController({
    this.topsterStore,
  });

  factory TopsterBoxesController.initialize({int totalBoxes}) {
    final List<TopsterBoxData> topsterStore = List<TopsterBoxData>.generate(
      totalBoxes,
      (index) => null,
    );
    return TopsterBoxesController(
      topsterStore: topsterStore,
    );
  }

  void removeUntilNullBox(int startIndex) {
    topsterStore.removeAt(startIndex);

    topsterStore.add(null);

    int endIndex = startIndex;
    while (topsterStore[endIndex] != null) {
      if (endIndex < topsterStore.length) {
        endIndex++;
      } else {
        topsterStore.removeLast();
        break;
      }
    }
    topsterStore.insert(endIndex, null);
    updateBoxes();
  }

  void insertUntilNullBox(int startIndex, TopsterBoxData data) {
    topsterStore.insert(startIndex, data);
    int endIndex = startIndex;
    while (topsterStore[endIndex] != null) {
      if (endIndex < topsterStore.length - 1) {
        endIndex++;
      } else {
        topsterStore.add(topsterStore.removeLast());
        break;
      }
    }
    topsterStore.removeAt(endIndex);
    updateBoxes();
  }

  void attachBox(int index, TopsterBoxData data) {
    topsterStore[index] = data;
    updateBoxes();
  }

  void detachBox(int index) {
    topsterStore[index] = null;

    updateBoxes();
  }

  void insertBox(int index, TopsterBoxData data) {
    topsterStore.insert(index, data);
    topsterStore.removeLast();
    updateBoxes();
  }

  void updateBoxes() {
    notifyListeners();
  }

  void insertRow(int index, int boxCount, List<int> rowsBoxCount) {
    int calculateSum(int index) {
      int sum = 0;
      for (int i = 0; i < index; i++) {
        sum += rowsBoxCount[i];
      }
      return sum;
    }

    final int boxIndex = calculateSum(index);
    for (int i = 0; i < boxCount; i++) {
      topsterStore.insert(boxIndex, null);
    }

    updateBoxes();
  }

  void removeRow(int index, List<int> rowsBoxCount) {
    int calculateSum(int index) {
      int sum = 0;
      for (int i = 0; i < index; i++) {
        sum += rowsBoxCount[i];
      }
      return sum;
    }

    final int boxCount = rowsBoxCount[index];
    final int boxIndex = calculateSum(index);
    for (int i = 0; i < boxCount; i++) {
      topsterStore.removeAt(boxIndex);
    }
    updateBoxes();
  }

  void onReorder(List<int> rowsBoxCount, int newIndex, int oldIndex) {
    int calculateSum(int index) {
      int sum = 0;
      for (int i = 0; i < index; i++) {
        sum += rowsBoxCount[i];
      }
      return sum;
    }

    void removeAndInsert(int boxCount, int boxOldIndex, int boxNewIndex) {
      for (int i = 0; i < boxCount; i++) {
        // ignore: parameter_assignments
        final temp = topsterStore.removeAt(boxOldIndex++);
        // ignore: parameter_assignments
        topsterStore.insert(boxNewIndex++, temp);
      }
    }

    void reorderUpToDown() {
      final int boxOldIndex = calculateSum(oldIndex);
      final int boxes = rowsBoxCount.removeAt(oldIndex);
      rowsBoxCount.insert(newIndex, boxes);
      final int boxCount = rowsBoxCount[newIndex];
      int boxNewIndex = calculateSum(newIndex);
      final List<TopsterBoxData> boxInsertList = [];
      for (int i = 0; i < boxCount; i++) {
        boxInsertList.add(topsterStore.removeAt(boxOldIndex));
      }
      for (int i = 0; i < boxInsertList.length; i++) {
        topsterStore.insert(boxNewIndex++, boxInsertList[i]);
      }
    }

    void reorderDownToUp() {
      final int boxCount = rowsBoxCount[oldIndex];
      final int boxOldIndex = calculateSum(oldIndex);
      final int boxNewIndex = calculateSum(newIndex);
      removeAndInsert(boxCount, boxOldIndex, boxNewIndex);
    }

    newIndex > oldIndex ? reorderUpToDown() : reorderDownToUp();
    updateBoxes();
  }
}
