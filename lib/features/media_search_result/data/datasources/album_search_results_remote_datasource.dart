import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/album_search_results_model.dart';

abstract class AlbumSearchResultRemoteDataSource {
  Future<AlbumSearchResultModel> getAlbumSearchResult(String searchTerm);
}

class AlbumSearchRemoteDataSourceImpl
    implements AlbumSearchResultRemoteDataSource {
  final http.Client client;
  AlbumSearchRemoteDataSourceImpl(this.client);
  @override
  Future<AlbumSearchResultModel> getAlbumSearchResult(
      String searchQuery) async {
    const String _apiKey = "3c44f1e47b785beb3cd9883ac7a1e062";
    final Uri uri = Uri(
      host: 'ws.audioscrobbler.com',
      scheme: 'https',
      path: '2.0',
      queryParameters: {
        "method": "album.search",
        "album": searchQuery,
        "api_key": _apiKey,
        "format": "json",
        "limit": "100"
      },
      // query:
      //     '?method=album.search&album=$searchQuery&api_key=$_apiKey&format=json&limit=100'
    );
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final parsedJson = await compute(decodeJson, response.body);
      return AlbumSearchResultModel.fromJson(parsedJson);
    } else {
      throw ServerException(Error());
    }
  }
}

Future<dynamic> decodeJson(String response) async {
  return json.decode(response);
}
