import 'package:flutter/material.dart';

import 'package:topsters/features/sliding_panel.dart/panel/panel.dart';

import 'core/injection_container.dart' as di;
import 'features/start_screen/start_screen.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showPerformanceOverlay: true,
      title: 'Topsters',
      home: Scaffold(body: StartScreen()),
    );
  }
}
