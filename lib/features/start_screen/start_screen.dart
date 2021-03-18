import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slimy_card/slimy_card.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topsters',
            style: GoogleFonts.aBeeZee(color: const Color(0xFFebebeb))),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF050505),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFebebeb),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          SlimyCard(
            color: const Color(0xFF867897),
            topCardHeight: 150,
            bottomCardHeight: 300,
            topCardWidget: Text('Previously Saved Topsters',
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                    color: const Color(0xFFebebeb), fontSize: 20)),
            bottomCardWidget: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List<Widget>.generate(
                    10,
                    (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFebebeb),
                                  elevation: 1,
                                  onSurface: const Color(0xFF867897)),
                              onPressed: () {},
                              child: Image.asset('assets/topsters_logo.png')),
                        ))),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          // Card(
          //     borderOnForeground: false,
          //     margin: EdgeInsets.all(30),
          //     clipBehavior: Clip.none,
          //     color: Color(0xFF000000),
          //     child: Text('Create new from scratch',
          //         textAlign: TextAlign.center,
          //         style: GoogleFonts.aBeeZee(
          //             color: Color(0xFFebebeb), fontSize: 20))),

          GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List<Widget>.generate(
                  10,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFFebebeb),
                                elevation: 1,
                                onSurface: const Color(0xFF867897)),
                            onPressed: () {},
                            child: Image.asset('assets/topsters_logo.png')),
                      ))),
        ],
      ),
    );
  }
}
