import 'package:rxdart/rxdart.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

class TopsterBoxesController {
  final int totalBoxes;
  final List<BehaviorSubject<TopsterBoxData>> boxStreams;
  final List<TopsterBoxData> topsterStore;

  TopsterBoxesController({this.totalBoxes, this.boxStreams, this.topsterStore});

  factory TopsterBoxesController.initialize(int totalBoxes) {
    List<BehaviorSubject<TopsterBoxData>> boxStreams =
        List<BehaviorSubject<TopsterBoxData>>.generate(
            totalBoxes, (index) => BehaviorSubject<TopsterBoxData>());
    List<TopsterBoxData> topsterStore =
        List<TopsterBoxData>.generate(totalBoxes, (index) => null);
    return TopsterBoxesController(
        totalBoxes: totalBoxes,
        boxStreams: boxStreams,
        topsterStore: topsterStore);
  }

  void attachTopster(int index, TopsterBoxData data) async {
    topsterStore[index] = data;
    boxStreams[index].sink.add(data);
  }

  void detachTopster(int index) async {
    topsterStore[index] = null;
    boxStreams[index].sink.add(null);
  }

  void insertTopster(int index, TopsterBoxData data) async {
    topsterStore.insert(index, data);
    topsterStore.removeLast();
    await resetTopsters(index);
  }

  void removeTopster(int index) async {
    topsterStore.removeAt(index);
    topsterStore.add(null);
    await resetTopsters(index);
  }

  Future<void> resetTopsters(int index) async {
    Iterator<TopsterBoxData> i = topsterStore.sublist(index).iterator;
    boxStreams.sublist(index).forEach((element) {
      i.moveNext();
      element.sink.add(i.current);
    });
  }

  void onReorder(List<int> layoutSizes, int newIndex, int oldIndex) {
    //print(layoutSizes);
    if (oldIndex > newIndex) {
      int start = 0;
      for (int i = 0; i < oldIndex; i++) {
        start = start + layoutSizes[i];
      }
      //print('Start:$start');
      int end = layoutSizes[oldIndex];
      //print('end:$end');
      if (newIndex == 0) {
        for (int i = 0; i < end; i++) {
          var temp = topsterStore.removeAt(start++);
          topsterStore.insert(i, temp);
        }
      } else {
        int a = 0;
        for (int i = 0; i < newIndex; i++) {
          //print(layoutSizes[i]);
          a = a + layoutSizes[i];
        }
        for (int i = 0; i < end; i++) {
          var temp = topsterStore.removeAt(start++);
          topsterStore.insert(a++, temp);
        }
      }
      resetTopsters(0);

      print(topsterStore);
    } else {
      print("ok");
      print(topsterStore);
      // print('old:$oldIndex');
      // print('new:$newIndex');
      List<int> lay = layoutSizes;
      print('lay$lay');
      //calculate sum until oldindex
      int oldindexsum = 0;
      for (int i = 0; i < oldIndex; i++) {
        oldindexsum = oldindexsum + lay[i];
      }
      print('oldindexsum:$oldindexsum');
      // remove and replace
      var val = lay.removeAt(oldIndex);
      print('lay$lay');
      lay.insert(newIndex, val);
      print('lay$lay');
      //calculate sum until newindex
      int newindexsum = 0;
      for (int i = 0; i < newIndex; i++) {
        newindexsum = newindexsum + lay[i];
      }
      print('newindexsum$newindexsum');
      List<TopsterBoxData> ministore = List<TopsterBoxData>();

      for (int i = 0; i < lay[newIndex]; i++) {
        //print(lay[newIndex]);
        // print('oldmaterial: $oldindexsum');
        // print('newmaterial: $newindexsum');
        // print('before:$topsterStore');
        var temp = topsterStore.removeAt(oldindexsum);
        // if (temp == null)
        //   print('null');
        // else
        //   print(temp.name);
        ministore.add(temp);

        //oldindexsum++;
        // topsterStore.insert(newindexsum, temp);
        // print('after$topsterStore');
        // newindexsum;
      }
      for (int i = 0; i < ministore.length; i++) {
        topsterStore.insert(newindexsum++, ministore[i]);
      }

      resetTopsters(0);
    }
  }
}
