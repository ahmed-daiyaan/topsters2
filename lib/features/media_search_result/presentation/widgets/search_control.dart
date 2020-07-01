import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_results_bloc.dart';

class SearchControl extends StatefulWidget {
  @override
  _SearchControlState createState() => _SearchControlState();
}

class _SearchControlState extends State<SearchControl> {
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        onChanged: (value) {
          inputStr = value;
        },
      ),
      Row(
        children: <Widget>[
          RaisedButton(
            child: Text("Album"),
            onPressed: () {
              addEvent(1);
            },
          ),
          RaisedButton(
            child: Text("Movie"),
            onPressed: () {
              addEvent(2);
            },
          ),
          RaisedButton(
            child: Text("TV Show"),
            onPressed: () {
              addEvent(3);
            },
          )
        ],
      )
    ]);
  }

  void addEvent(int n) {
    switch (n) {
      case 1:
        BlocProvider.of<SearchResultBloc>(context)
            .add(GetSearchResultForAlbum(inputStr));
        break;
      case 2:
        BlocProvider.of<SearchResultBloc>(context)
            .add(GetSearchResultForMovie(inputStr));
        break;
      case 3:
        BlocProvider.of<SearchResultBloc>(context)
            .add(GetSearchResultForTVShow(inputStr));
        break;
      default:
    }
  }
}
