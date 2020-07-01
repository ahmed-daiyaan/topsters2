import 'package:meta/meta.dart';

import '../../domain/entities/search_results.dart';

class AlbumSearchResultModel extends SearchResult {
  AlbumSearchResultModel({
    @required albumNames,
    @required artistNames,
    @required albumImages,
    @required totalResults,
  }) : super(
            mediaNames: albumNames,
            secondaryFields: artistNames,
            mediaImages: albumImages,
            totalResults: totalResults);

  factory AlbumSearchResultModel.fromJson(Map<String, dynamic> json) {
    List<String> albumNames = List<String>();
    List<String> albumImages = List<String>();
    List<String> artistNames = List<String>();
    bool _testIfImageIsNull;
    int count = 0;
    String _testImageString;
    int resultsCap = int.parse(json['results']['opensearch:totalResults']);

    if (resultsCap >= 97) resultsCap = 97;

    for (int index = 0; index < resultsCap; index++) {
      try {
        _testImageString = json['results']['albummatches']['album'][index]
            ['image'][3]['#text'];
        if (_testImageString == null || _testImageString == "")
          _testIfImageIsNull = true;
        else
          _testIfImageIsNull = false;
        if (!_testIfImageIsNull) {
          albumNames
              .add(json['results']['albummatches']['album'][index]['name']);
          artistNames
              .add(json['results']['albummatches']['album'][index]['artist']);
          albumImages.add(_testImageString);
          count++;
        }
      } catch (e) {
        print(e);
      }
    }
    return AlbumSearchResultModel(
      totalResults: count,
      albumNames: albumNames,
      artistNames: artistNames,
      albumImages: albumImages,
    );
  }
}
