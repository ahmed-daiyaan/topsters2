import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/injection_container.dart' as di;
import 'features/start_screen/start_screen.dart';

void main() {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showPerformanceOverlay: true,
      title: 'Topsters',
      home: Scaffold(
          backgroundColor: const Color(0xFFebebeb),
          appBar: AppBar(
            title: Text('Topsters',
                style: GoogleFonts.aBeeZee(color: const Color(0xFFebebeb))),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF050505),
            centerTitle: true,
          ),
          body: StartScreen()),
    );
  }
}
