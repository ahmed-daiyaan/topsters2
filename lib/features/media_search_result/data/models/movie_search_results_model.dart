import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/search_results.dart';

class MovieSearchResultModel extends SearchResult {
  const MovieSearchResultModel({
    @required List<String> movieNames,
    @required List<String> movieReleaseDates,
    @required List<String> movieImages,
    @required int totalResults,
  }) : super(
            mediaNames: movieNames,
            secondaryFields: movieReleaseDates,
            mediaImages: movieImages,
            totalResults: totalResults);

  factory MovieSearchResultModel.fromJson(List jsons) {
    final List<String> movieNames = [];
    final List<String> movieImages = [];
    final List<String> movieReleaseDates = [];
    int count = 0;
    bool _testIfFieldsAreNull;
    String _testImageString;
    String _testNameString;
    String _testSecondFieldString;
    int index = 0;
    for (int i = 0; i < jsons.length; i++) {
      final json = jsons[i];

      for (index = 0;
          index < int.parse(json['results'].length.toString());
          index++) {
        _testImageString = json['results'][index]['poster_path'].toString();
        _testNameString = json['results'][index]['title'].toString();
        _testSecondFieldString =
            json['results'][index]['release_date'].toString();
        if (_testImageString == "null" ||
            _testImageString == "" ||
            _testNameString == "null" ||
            _testNameString == "" ||
            _testSecondFieldString == "null" ||
            _testSecondFieldString == "") {
          _testIfFieldsAreNull = true;
        } else {
          _testIfFieldsAreNull = false;
        }
        if (!_testIfFieldsAreNull) {
          movieNames.add(_testNameString);
          movieReleaseDates.add(_testSecondFieldString);
          movieImages
              .add("http://image.tmdb.org/t/p/original/$_testImageString");
          count++;
        }
      }
    }
    return MovieSearchResultModel(
      totalResults: count,
      movieNames: movieNames,
      movieReleaseDates: movieReleaseDates,
      movieImages: movieImages,
    );
  }
}
