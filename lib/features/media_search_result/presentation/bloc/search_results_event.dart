part of 'search_results_bloc.dart';

abstract class SearchResultEvent extends Equatable {
  const SearchResultEvent();
}

class GetSearchResultForAlbum extends SearchResultEvent {
  final String searchQuery;

  const GetSearchResultForAlbum(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}

class GetSearchResultForMovie extends SearchResultEvent {
  final String searchQuery;

  const GetSearchResultForMovie(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}

class GetSearchResultForTVShow extends SearchResultEvent {
  final String searchQuery;

  const GetSearchResultForTVShow(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}
