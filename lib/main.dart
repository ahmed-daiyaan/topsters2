import 'package:flutter/material.dart';
import 'package:topsters/features/onboarding_screen/topsters_onboarding.dart';
import 'package:topsters/features/topster_layout/layout.dart';
import 'features/media_search_result/presentation/pages/search_page.dart';
import 'core/injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //checkerboardRasterCacheImages: true,
        // checkerboardOffscreenLayers: true,
        showPerformanceOverlay: true,
        title: 'AlbumSearchResults',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TopsterLayout());
  }
}
