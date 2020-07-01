part of 'search_results_bloc.dart';

abstract class SearchResultState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends SearchResultState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class Loading extends SearchResultState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class Loaded extends SearchResultState {
  final SearchResult searchResult;
  Loaded(this.searchResult);
  @override
  List<Object> get props => [searchResult];
}

class Error extends SearchResultState {
  final String message;
  Error(this.message);

  List<Object> get props => [message];
}
