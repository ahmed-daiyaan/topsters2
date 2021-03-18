import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SearchResult extends Equatable {
  final int totalResults;
  final List<dynamic> mediaNames;
  final List<dynamic> mediaImages;
  final List<dynamic> secondaryFields;
  const SearchResult({
    @required this.totalResults,
    @required this.secondaryFields,
    @required this.mediaNames,
    @required this.mediaImages,
  });

  @override
  List<Object> get props => [
        totalResults,
        mediaNames,
        mediaImages,
        secondaryFields,
      ];
}
