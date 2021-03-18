import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

import '../features/media_search_result/data/datasources/album_search_results_remote_datasource.dart';
import '../features/media_search_result/data/datasources/movie_search_results_remote_datasource.dart';
import '../features/media_search_result/data/datasources/tvshow_search_results_remote_data_source.dart';
import '../features/media_search_result/data/repositories/search_results_repository_impl.dart';
import '../features/media_search_result/domain/repositories/search_results_repository.dart';
import '../features/media_search_result/domain/usecases/get_album_search_results.dart';
import '../features/media_search_result/domain/usecases/get_movie_search_result.dart';
import '../features/media_search_result/domain/usecases/get_tvshow_search_result.dart';
import '../features/media_search_result/presentation/bloc/search_results_bloc.dart';
import 'network/networkinfo.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //Features - Number Trivia
  //Bloc
  sl.registerFactory(() => SearchResultBloc(
        GetAlbumSearchResult(sl()),
        GetMovieSearchResult(sl()),
        GetTVShowSearchResult(sl()),
      ));
  sl.registerLazySingleton(() => GetAlbumSearchResult(sl()));
  sl.registerLazySingleton(() => GetTVShowSearchResult(sl()));
  //Repository
  sl.registerLazySingleton<SearchResultRepository>(() =>
      SearchResultRepositoryImpl(
          networkInfo: sl(),
          albumRemoteDataSource: sl(),
          movieRemoteDataSource: sl(),
          tvShowRemoteDataSource: sl()));
  //Data
  sl.registerLazySingleton<TopsterBoxesController>(
      () => TopsterBoxesController(topsterStore: sl()));
  sl.registerLazySingleton<TopsterBoxData>(() => TopsterBoxData());

  sl.registerLazySingleton<AlbumSearchResultRemoteDataSource>(
      () => AlbumSearchRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<MovieSearchResultRemoteDataSource>(
      () => MovieSearchRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TVShowSearchResultRemoteDataSource>(
      () => TVShowSearchRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

  // sl.registerLazySingleton(
  //     () => ImageStore(imageRepository: sl(), boxStatus: sl()));

  //Core
  //External
}
