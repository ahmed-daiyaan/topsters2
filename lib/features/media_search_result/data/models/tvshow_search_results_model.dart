import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/search_results.dart';

class TVShowSearchResultModel extends SearchResult {
  const TVShowSearchResultModel({
    @required List<String> tvshowNames,
    @required List<String> tvshowStartDates,
    @required List<String> tvshowImages,
    @required int totalResults,
  }) : super(
            mediaNames: tvshowNames,
            secondaryFields: tvshowStartDates,
            mediaImages: tvshowImages,
            totalResults: totalResults);

  factory TVShowSearchResultModel.fromJson(List jsons) {
    final List<String> tvshowNames = [];
    final List<String> tvshowImages = [];
    final List<String> tvshowStartDates = [];

    int count = 0;
    String imageUrl;
    String name;
    String secondField;

    bool filterResult(String name, String imageUrl, String secondField) {
      if (imageUrl == "null" ||
          imageUrl == "" ||
          name == "null" ||
          name == "" ||
          secondField == "null" ||
          secondField == "") {
        return true;
      } else {
        return false;
      }
    }

    for (int i = 0; i < jsons.length; i++) {
      final json = jsons[i];
      for (int index = 0;
          index < int.parse(json['results'].length.toString());
          index++) {
        imageUrl = json['results'][index]['poster_path'].toString();
        name = json['results'][index]['name'].toString();
        secondField = json['results'][index]['first_air_date'].toString();

        if (filterResult(name, imageUrl, secondField) == false) {
          tvshowNames.add(name);
          tvshowStartDates.add(secondField);
          tvshowImages.add("http://image.tmdb.org/t/p/original/ imageUrl");
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
