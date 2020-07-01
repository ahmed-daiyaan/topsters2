import 'package:rxdart/rxdart.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

class TopsterBoxesController {
  final int totalBoxes;
  final List<BehaviorSubject<TopsterBoxData>> boxStreams;
  final List<TopsterBoxData> topsterStore;
  TopsterBoxesController({
    this.totalBoxes,
    this.boxStreams,
    this.topsterStore,
  });

  factory TopsterBoxesController.initialize(
      {int totalBoxes, List<int> layoutSizes}) {
    List<BehaviorSubject<TopsterBoxData>> boxStreams =
        List<BehaviorSubject<TopsterBoxData>>.generate(
            totalBoxes, (index) => BehaviorSubject<TopsterBoxData>());
    List<TopsterBoxData> topsterStore =
        List<TopsterBoxData>.generate(totalBoxes, (index) => null);
    return TopsterBoxesController(
      totalBoxes: totalBoxes,
      boxStreams: boxStreams,
      topsterStore: topsterStore,
    );
  }

  removeUntilNullTopster(int startIndex) {
    topsterStore.removeAt(startIndex);
    int endIndex = startIndex;
    while (topsterStore[endIndex] != null) endIndex++;
    topsterStore.insert(endIndex, null);
    resetUntilNullTopster(startIndex, ++endIndex);
  }

  insertUntilNullTopster(int startIndex, TopsterBoxData data) {
    topsterStore.insert(startIndex, data);
    int endIndex = startIndex;
    while (topsterStore[endIndex] != null) endIndex++;
    topsterStore.removeAt(endIndex);
    resetUntilNullTopster(startIndex, endIndex);
  }

  resetUntilNullTopster(int startIndex, endIndex) {
    Iterator<TopsterBoxData> i =
        topsterStore.sublist(startIndex, endIndex).iterator;
    boxStreams.sublist(startIndex, endIndex).forEach((element) {
      i.moveNext();
      element.sink.add(i.current);
    });
  }

  attachTopster(int index, TopsterBoxData data) {
    topsterStore[index] = data;
    boxStreams[index].sink.add(data);
  }

  detachTopster(int index) {
    topsterStore[index] = null;
    boxStreams[index].sink.add(null);
  }

  void insertTopster(int index, TopsterBoxData data) {
    topsterStore.insert(index, data);
    topsterStore.removeLast();
    resetTopsters(index);
  }

  removeTopster(int index) {
    topsterStore.removeAt(index);
    topsterStore.add(null);
    resetTopsters(index);
  }

  resetTopsters(int index) {
    Iterator<TopsterBoxData> i = topsterStore.sublist(index).iterator;
    boxStreams.sublist(index).forEach((element) {
      i.moveNext();
      element.sink.add(i.current);
    });
  }

  onReorder(List<int> layoutSizes, int newIndex, int oldIndex) {
    calculateSum(int index) {
      int sum = 0;
      for (int i = 0; i < index; i++) {
        sum += layoutSizes[i];
      }
      return sum;
    }

    removeAndInsert(int boxCount, int boxOldIndex, int boxNewIndex) {
      for (int i = 0; i < boxCount; i++) {
        var temp = topsterStore.removeAt(boxOldIndex++);
        topsterStore.insert(boxNewIndex++, temp);
      }
    }

    reorderUpToDown() {
      int boxOldIndex = calculateSum(oldIndex);
      int boxes = layoutSizes.removeAt(oldIndex);
      layoutSizes.insert(newIndex, boxes);
      int boxCount = layoutSizes[newIndex];
      int boxNewIndex = calculateSum(newIndex);
      List<TopsterBoxData> boxInsertList = List<TopsterBoxData>();
      for (int i = 0; i < boxCount; i++) {
        var temp = topsterStore.removeAt(boxOldIndex);
        boxInsertList.add(temp);
      }
      for (int i = 0; i < boxInsertList.length; i++) {
        topsterStore.insert(boxNewIndex++, boxInsertList[i]);
      }
    }

    reorderDownToUp() {
      int boxCount = layoutSizes[oldIndex];
      int boxOldIndex = calculateSum(oldIndex);
      int boxNewIndex = calculateSum(newIndex);
      removeAndInsert(boxCount, boxOldIndex, boxNewIndex);
    }

    newIndex > oldIndex ? reorderUpToDown() : reorderDownToUp();
    resetTopsters(0);
  }
}
