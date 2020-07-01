class ServerException implements Exception {
  ServerException(Error e) {
    print(e.toString());
  }
}

class CacheException implements Exception {}
