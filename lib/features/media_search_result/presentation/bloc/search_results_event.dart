part of 'search_results_bloc.dart';

abstract class SearchResultEvent extends Equatable {
  const SearchResultEvent();
}

class GetSearchResultForAlbum extends SearchResultEvent {
  final String searchQuery;

  GetSearchResultForAlbum(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}

class GetSearchResultForMovie extends SearchResultEvent {
  final String searchQuery;

  GetSearchResultForMovie(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}

class GetSearchResultForTVShow extends SearchResultEvent {
  final String searchQuery;

  GetSearchResultForTVShow(this.searchQuery);
  @override
  List<Object> get props => [searchQuery];
}
