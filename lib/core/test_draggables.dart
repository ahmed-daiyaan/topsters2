import 'package:flutter/material.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

class TestDraggables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Draggable<TopsterBoxData>(
        child: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            child: RepaintBoundary(
              child: Image.network(
                  "https://lastfm.freetls.fastly.net/i/u/300x300/3061a718bafbccc70ac73c7dafec6a09.png",
                  fit: BoxFit.fill),
            )),
        feedback: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            child: RepaintBoundary(
              child: Image.network(
                  "https://lastfm.freetls.fastly.net/i/u/300x300/3061a718bafbccc70ac73c7dafec6a09.png",
                  fit: BoxFit.fill),
            )),
        childWhenDragging: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            child: Image.network(
                "https://lastfm.freetls.fastly.net/i/u/300x300/3061a718bafbccc70ac73c7dafec6a09.png",
                fit: BoxFit.fill)),
        data: TopsterBoxData(
            image: Image.network(
                "https://lastfm.freetls.fastly.net/i/u/300x300/3061a718bafbccc70ac73c7dafec6a09.png",
                fit: BoxFit.cover),
            name: "Melodrama",
            secondaryField: "Lorde"),
      ),
      Draggable<TopsterBoxData>(
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
            image: Image.network(
              'https://lastfm.freetls.fastly.net/i/u/300x300/15ef1c034e1f6a71d0d69d3b6f5c534f.png',
              fit: BoxFit.contain,
            ),
            name: "Artpop",
            secondaryField: "Lady Gaga"),
      ),
      // RaisedButton(
      //   onPressed: () {
      //   },
      // )
    ]);
  }
}
