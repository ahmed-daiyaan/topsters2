import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/usecases/get_album_search_results.dart';
import '../../domain/usecases/get_movie_search_result.dart';
import '../../domain/usecases/get_tvshow_search_result.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

// ignore: constant_identifier_names
const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final GetAlbumSearchResult getAlbumSearchResult;
  final GetMovieSearchResult getMovieSearchResult;
  final GetTVShowSearchResult getTVShowSearchResult;
  SearchResultBloc(this.getAlbumSearchResult, this.getMovieSearchResult,
      this.getTVShowSearchResult)
      : super(Empty());
  @override
  Stream<SearchResultState> mapEventToState(
    SearchResultEvent event,
  ) async* {
    if (event is GetSearchResultForMovie) {
      yield Loading();
      final failureOrSearchResult =
          await getMovieSearchResult(Params(searchQuery: event.searchQuery));
      yield failureOrSearchResult.fold(
          (failure) => Error(_mapFailureToMessage(failure)),
          (result) => Loaded(result));
    } else if (event is GetSearchResultForAlbum) {
      yield Loading();
      final failureOrSearchResult =
          await getAlbumSearchResult(Params(searchQuery: event.searchQuery));
      yield failureOrSearchResult.fold(
          (failure) => Error(_mapFailureToMessage(failure)),
          (result) => Loaded(result));
    } else if (event is GetSearchResultForTVShow) {
      yield Loading();
      final failureOrSearchResult =
          await getTVShowSearchResult(Params(searchQuery: event.searchQuery));
      yield failureOrSearchResult.fold(
          (failure) => Error(_mapFailureToMessage(failure)),
          (result) => Loaded(result));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
