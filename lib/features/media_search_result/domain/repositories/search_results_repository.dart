import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/search_results.dart';

//We're not actually implementing the repository here, we are going to implement it in the data layer so this is an abstract class that when the data comes it will return either a failure or an AlbumSearchResult
abstract class SearchResultRepository {
  Future<Either<Failure, SearchResult>> getAlbumSearchResult(
      String searchQuery);
  Future<Either<Failure, SearchResult>> getMovieSearchResult(
      String searchQuery);
  Future<Either<Failure, SearchResult>> getTVShowSearchResult(
      String searchQuery);
}
