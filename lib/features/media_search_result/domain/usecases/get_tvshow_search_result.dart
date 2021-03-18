import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_results.dart';
import '../repositories/search_results_repository.dart';

class GetTVShowSearchResult implements Usecase<SearchResult, Params> {
  final SearchResultRepository repository;
  GetTVShowSearchResult(this.repository);
  @override
  Future<Either<Failure, SearchResult>> call(Params params) async {
    return repository.getTVShowSearchResult(params.searchQuery);
  }
}
