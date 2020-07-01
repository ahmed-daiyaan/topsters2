import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/tvshow_search_results_model.dart';

abstract class TVShowSearchResultRemoteDataSource {
  Future<TVShowSearchResultModel> getTVShowSearchResult(String searchQuery);
}

class TVShowSearchRemoteDataSourceImpl
    implements TVShowSearchResultRemoteDataSource {
  final http.Client client;
  TVShowSearchRemoteDataSourceImpl(this.client);
  @override
  Future<TVShowSearchResultModel> getTVShowSearchResult(
      String searchQuery) async {
    final String _apiKey = "0a239c3800565940613463165cf38863";
    final List<http.Response> undecodedResponses = List<http.Response>();
    List<Map<String, dynamic>> responses = List<Map<String, dynamic>>();
    Response undecodedResponse;
    final initialResponse = await client.get(
        "https://api.themoviedb.org/3/search/tv?api_key=" +
            _apiKey +
            "&query=" +
            searchQuery +
            "&language=en-US&include_adult=false");
    var pagesResponse = await compute(decodeJson, initialResponse.body);
    responses.add(pagesResponse);
    int pages = pagesResponse['total_pages'];

    if (pages > 5) pages = 5;
    for (int i = 2; i <= pages; i++) {
      undecodedResponse = await client.get(
          "https://api.themoviedb.org/3/search/tv?api_key=" +
              _apiKey +
              "&query=" +
              searchQuery +
              "&language=en-US&include_adult=false&page=" +
              i.toString());
      var response = await compute(decodeJson, undecodedResponse.body);
      responses.add(response);
    }
    try {
      if (undecodedResponses[undecodedResponses.length - 1].statusCode == 200) {
        responses = List.generate(undecodedResponses.length,
            (index) => json.decode(undecodedResponses[index].body));
        return TVShowSearchResultModel.fromJson(responses);
      } else {
        throw ServerException(Error());
      }
    } on RangeError {
      throw ServerException(Error());
    }
  }
}

Future<Map<String, dynamic>> decodeJson(var response) async {
  return json.decode(response);
}
