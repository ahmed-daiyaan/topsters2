import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/search_results.dart';

class AlbumSearchResultModel extends SearchResult {
  const AlbumSearchResultModel({
    @required List<String> albumNames,
    @required List<String> artistNames,
    @required List<String> albumImages,
    @required int totalResults,
  }) : super(
            mediaNames: albumNames,
            secondaryFields: artistNames,
            mediaImages: albumImages,
            totalResults: totalResults);

  factory AlbumSearchResultModel.fromJson(dynamic json) {
    final List<String> albumNames = [];
    final List<String> albumImages = [];
    final List<String> artistNames = [];
    bool _testIfImageIsNull;
    int count = 0;
    String _testImageString;
    int resultsCap =
        int.parse(json['results']['opensearch:totalResults'].toString());

    if (resultsCap >= 97) resultsCap = 97;

    for (int index = 0; index < resultsCap; index++) {
      try {
        _testImageString = json['results']['albummatches']['album'][index]
                ['image'][3]['#text']
            .toString();
        if (_testImageString == null || _testImageString == "") {
          _testIfImageIsNull = true;
        } else {
          _testIfImageIsNull = false;
        }
        if (!_testIfImageIsNull) {
          albumNames.add(json['results']['albummatches']['album'][index]['name']
              .toString());
          artistNames.add(json['results']['albummatches']['album'][index]
                  ['artist']
              .toString());
          albumImages.add(_testImageString);
          count++;
        }
      } catch (e) {
        debugPrint(e.toString());
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
