import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/networkinfo.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/repositories/search_results_repository.dart';
import '../datasources/album_search_results_remote_datasource.dart';
import '../datasources/movie_search_results_remote_datasource.dart';
import '../datasources/tvshow_search_results_remote_data_source.dart';

typedef Future<SearchResult> _MediaChooser();

class SearchResultRepositoryImpl implements SearchResultRepository {
  final AlbumSearchResultRemoteDataSource albumRemoteDataSource;
  final MovieSearchResultRemoteDataSource movieRemoteDataSource;
  final TVShowSearchResultRemoteDataSource tvShowRemoteDataSource;
  final NetworkInfo networkInfo;

  SearchResultRepositoryImpl({
    @required this.albumRemoteDataSource,
    @required this.movieRemoteDataSource,
    @required this.tvShowRemoteDataSource,
    @required this.networkInfo,
  });
  @override
  Future<Either<Failure, SearchResult>> getAlbumSearchResult(
      String searchQuery) async {
    return await _getResult(() {
      return albumRemoteDataSource.getAlbumSearchResult(searchQuery);
    });
  }

  @override
  Future<Either<Failure, SearchResult>> getMovieSearchResult(
      String searchQuery) async {
    return await _getResult(() {
      return movieRemoteDataSource.getMovieSearchResult(searchQuery);
    });
  }

  @override
  Future<Either<Failure, SearchResult>> getTVShowSearchResult(
      String searchQuery) async {
    return await _getResult(() {
      return tvShowRemoteDataSource.getTVShowSearchResult(searchQuery);
    });
  }

  Future<Either<Failure, SearchResult>> _getResult(
    _MediaChooser getMedia,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchResult = await getMedia();
        return Right(remoteSearchResult);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else
      return (Left(ServerFailure()));
  }
}
