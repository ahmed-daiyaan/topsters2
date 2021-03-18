import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

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
    const String _apiKey = "0a239c3800565940613463165cf38863";
    //final List<http.Response> undecodedResponses = List<http.Response>();
    final List<Map<String, dynamic>> responses = [];
    Response undecodedResponse;
    final initialResponse = await client.get(
        "https://api.themoviedb.org/3/search/tv?api_key=$_apiKey&query=$searchQuery&language=en-US&include_adult=false");
    final pagesDecodeJson = await compute(decodeJson, initialResponse.body);

    int pages = pagesDecodeJson['total_pages'] as int;
    responses.add(pagesDecodeJson as Map<String, dynamic>);
    if (pages > 5) pages = 5;
    for (int i = 2; i <= pages; i++) {
      undecodedResponse = await client.get(
          "https://api.themoviedb.org/3/search/tv?api_key=$_apiKey&query=$searchQuery&language=en-US&include_adult=false&page=$i");
      final response = await compute(decodeJson, undecodedResponse.body);
      responses.add(response as Map<String, dynamic>);
    }
    return TVShowSearchResultModel.fromJson(responses);
  }
  //   if (initialResponse.statusCode == 200) {
  //     responses = List.generate(undecodedResponses.length,
  //         (index) => json.decode(undecodedResponses[index].body));
  //     return TVShowSearchResultModel.fromJson(responses);
  //   } else {
  //     throw ServerException(Error());
  //   }
  // }
}

Future<dynamic> decodeJson(String response) async {
  return json.decode(response);
}
