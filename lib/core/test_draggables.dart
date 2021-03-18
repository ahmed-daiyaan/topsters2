import 'package:flutter/material.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

class TestDraggables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: <Widget>[
        Draggable<TopsterBoxData>(
          // ignore: sort_child_properties_last
          child: Container(
              height: 50,
              width: 50,
              color: Colors.red,
              child: RepaintBoundary(
                child: Image.network(
                  "http://image.tmdb.org/t/p/original/wjx1GfVyaATVbKozljXjQZZulNy.jpg",
                ),
              )),
          feedback: Container(
              height: 50,
              width: 50,
              color: Colors.red,
              child: RepaintBoundary(
                child: Image.network(
                  "http://image.tmdb.org/t/p/original/wjx1GfVyaATVbKozljXjQZZulNy.jpg",
                ),
              )),
          // childWhenDragging: Container(
          //     //  height: 50,
          //     //  width: 50,
          //     color: Colors.red,
          //     child: Image.network(
          //       "http://image.tmdb.org/t/p/original/wjx1GfVyaATVbKozljXjQZZulNy.jpg",
          //     )),
          data: TopsterBoxData(
              image:
                  //Image.network(
                  "http://image.tmdb.org/t/p/original/wjx1GfVyaATVbKozljXjQZZulNy.jpg",
              //fit: BoxFit.contain),
              name: "Melodrama",
              secondaryField: "Lorde"),
        ),
        Draggable<TopsterBoxData>(
          feedback: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            child: Image.network(
              "https://lastfm.freetls.fastly.net/i/u/300x300/15ef1c034e1f6a71d0d69d3b6f5c534f.png",
              fit: BoxFit.fill,
              // cacheHeight: 10,
              // cacheWidth: 10,
            ),
          ),
          childWhenDragging: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            child: Image.network(
              "https://lastfm.freetls.fastly.net/i/u/300x300/15ef1c034e1f6a71d0d69d3b6f5c534f.png",
              fit: BoxFit.fill,
              // cacheHeight: 10,
              // cacheWidth: 10,
            ),
          ),
          data: TopsterBoxData(
              image:
                  //Image.network(
                  'https://lastfm.freetls.fastly.net/i/u/300x300/15ef1c034e1f6a71d0d69d3b6f5c534f.png',
              //   fit: BoxFit.contain,  ),
              name: "Artpop",
              secondaryField: "Lady Gaga"),
          child: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            child: Image.network(
              "https://lastfm.freetls.fastly.net/i/u/300x300/15ef1c034e1f6a71d0d69d3b6f5c534f.png",
              fit: BoxFit.fill,
              cacheHeight: 200,
              cacheWidth: 200,
            ),
          ),
        ),
        // RaisedButton(
        //   onPressed: () {
        //   },
        // )
      ]),
    );
  }
}
