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
    const String _apiKey = "0a239c3800565940613463165cf38863";
    final List<Map<String, dynamic>> responses = [];
    Response undecodedResponse;
    final initialResponse = await client.get(
        "https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$searchQuery&language=en-US&include_adult=false");
    final pagesDecodeJson = await compute(decodeJson, initialResponse.body);
    int pages = pagesDecodeJson['total_pages'] as int;
    responses.add(pagesDecodeJson as Map<String, dynamic>);
    if (pages > 5) pages = 5;
    for (int i = 2; i <= pages; i++) {
      undecodedResponse = await client.get(
          "https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$searchQuery&language=en-US&include_adult=false&page=$i");
      final response = await compute(decodeJson, undecodedResponse.body);
      responses.add(response as Map<String, dynamic>);
    }
    return MovieSearchResultModel.fromJson(responses);
  }
}

Future<dynamic> decodeJson(String response) async {
  return json.decode(response);
}
