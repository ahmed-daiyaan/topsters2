import 'package:flutter/widgets.dart';

class ServerException implements Exception {
  ServerException(Error e) {
    debugPrint(e.toString());
  }
}

class CacheException implements Exception {}
