import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/search_results.dart';

class TVShowSearchResultModel extends SearchResult {
  TVShowSearchResultModel({
    @required tvshowNames,
    @required tvshowStartDates,
    @required tvshowImages,
    @required totalResults,
  }) : super(
            mediaNames: tvshowNames,
            secondaryFields: tvshowStartDates,
            mediaImages: tvshowImages,
            totalResults: totalResults);

  factory TVShowSearchResultModel.fromJson(List<Map<String, dynamic>> jsons) {
    List<String> tvshowNames = List<String>();
    List<String> tvshowImages = List<String>();
    List<String> tvshowStartDates = List<String>();
    bool _testIfFieldsAreNull;
    int count = 0;
    String _testImageString;
    String _testNameString;
    String _testSecondFieldString;
    int index = 0;

    for (int i = 0; i < jsons.length; i++) {
      var json = jsons[i];
      for (index = 0; index < json['results'].length; index++) {
        _testImageString = json['results'][index]['poster_path'];
        _testNameString = json['results'][index]['name'];
        _testSecondFieldString = json['results'][index]['first_air_date'];
        if (_testImageString == null ||
            _testImageString == "" ||
            _testNameString == null ||
            _testNameString == "" ||
            _testSecondFieldString == null ||
            _testSecondFieldString == "")
          _testIfFieldsAreNull = true;
        else
          _testIfFieldsAreNull = false;
        if (!_testIfFieldsAreNull) {
          tvshowNames.add(_testNameString);
          tvshowStartDates.add(_testSecondFieldString);
          tvshowImages
              .add("http://image.tmdb.org/t/p/original" + _testImageString);
          count++;
        }
      }
    }
    return TVShowSearchResultModel(
      totalResults: count,
      tvshowNames: tvshowNames,
      tvshowStartDates: tvshowStartDates,
      tvshowImages: tvshowImages,
    );
  }
}
