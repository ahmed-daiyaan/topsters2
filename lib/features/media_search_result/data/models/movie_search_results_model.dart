import 'package:meta/meta.dart';

import '../../domain/entities/search_results.dart';

class MovieSearchResultModel extends SearchResult {
  MovieSearchResultModel({
    @required movieNames,
    @required movieReleaseDates,
    @required movieImages,
    @required totalResults,
  }) : super(
            mediaNames: movieNames,
            secondaryFields: movieReleaseDates,
            mediaImages: movieImages,
            totalResults: totalResults);

  factory MovieSearchResultModel.fromJson(List<Map<String, dynamic>> jsons) {
    List<String> movieNames = List<String>();
    List<String> movieImages = List<String>();
    List<String> movieReleaseDates = List<String>();
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
        _testNameString = json['results'][index]['title'];
        _testSecondFieldString = json['results'][index]['release_date'];
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
          movieNames.add(_testNameString);
          movieReleaseDates.add(_testSecondFieldString);
          movieImages
              .add("http://image.tmdb.org/t/p/original" + _testImageString);
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
