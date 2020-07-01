import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../models/movie_search_results_model.dart';

abstract class MovieSearchResultRemoteDataSource {
  Future<MovieSearchResultModel> getMovieSearchResult(String searchQuery);
}

class MovieSearchRemoteDataSourceImpl
    implements MovieSearchResultRemoteDataSource {
  final http.Client client;
  MovieSearchRemoteDataSourceImpl(this.client);

  @override
  Future<MovieSearchResultModel> getMovieSearchResult(
      String searchQuery) async {
    final String _apiKey = "0a239c3800565940613463165cf38863";
    List<Map<String, dynamic>> responses = List<Map<String, dynamic>>();
    Response undecodedResponse;
    final initialResponse = await client.get(
        "https://api.themoviedb.org/3/search/movie?api_key=" +
            _apiKey +
            "&query=" +
            searchQuery +
            "&language=en-US&include_adult=false");
    var pagesDecodeJson = await compute(decodeJson, initialResponse.body);
    int pages = pagesDecodeJson['total_pages'];
    responses.add(pagesDecodeJson);
    if (pages > 5) pages = 5;
    for (int i = 2; i <= pages; i++) {
      undecodedResponse = await client.get(
          "https://api.themoviedb.org/3/search/movie?api_key=" +
              _apiKey +
              "&query=" +
              searchQuery +
              "&language=en-US&include_adult=false&page=" +
              i.toString());
      var response = await compute(decodeJson, undecodedResponse.body);
      responses.add(response);
    }
    return MovieSearchResultModel.fromJson(responses);
  }
}

Future<Map<String, dynamic>> decodeJson(var response) async {
  return json.decode(response);
}
