import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_results.dart';
import '../repositories/search_results_repository.dart';

class GetMovieSearchResult implements Usecase<SearchResult, Params> {
  final SearchResultRepository repository;
  GetMovieSearchResult(this.repository);
  @override
  Future<Either<Failure, SearchResult>> call(Params params) async {
    return repository.getMovieSearchResult(params.searchQuery);
  }
}
