import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

import '../bloc/search_results_bloc.dart';

BehaviorSubject<bool> searchBarStatusStream = BehaviorSubject<bool>();

class Searchh extends StatefulWidget {
  @override
  _SearchhState createState() => _SearchhState();
}

void addEvent(BuildContext context, String searchQuery) {
  BlocProvider.of<SearchResultBloc>(context)
      .add(GetSearchResultForAlbum(searchQuery));
}

class _SearchhState extends State<Searchh> {
  @override
  void dispose() {
    searchBarStatusStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: <Widget>[
          AnimatedTextField(),
          AnimatedSearchIcon(),
        ]));
  }
}

class AnimatedSearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: searchBarStatusStream,
        initialData: false,
        builder: (context, snapshot) {
          return AnimatedPositioned(
            top: 11,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubic,
            left: snapshot.data
                ? MediaQuery.of(context).size.width / 1.38
                : MediaQuery.of(context).size.width / 2 - 20,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.pink,
              child: AnimatedIconSwitcher(),
            ),
          );
        });
  }
}

class AnimatedIconSwitcher extends StatelessWidget {
  const AnimatedIconSwitcher({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        switchInCurve: Curves.easeInCubic,
        switchOutCurve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 1000),
        child: StreamBuilder<bool>(
            stream: searchBarStatusStream,
            initialData: false,
            builder: (context, snapshot) {
              return snapshot.data
                  ? IconButton(
                      iconSize: 20,
                      key: UniqueKey(),
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        snapshot.data
                            ? searchBarStatusStream.sink.add(!snapshot.data)
                            : searchBarStatusStream.sink.add(snapshot.data);
                      },
                    )
                  : IconButton(
                      iconSize: 20,
                      key: UniqueKey(),
                      icon: Icon(Icons.search),
                      onPressed: () {
                        !snapshot.data
                            ? searchBarStatusStream.sink.add(!snapshot.data)
                            : searchBarStatusStream.sink.add(snapshot.data);
                      });
            }),
        transitionBuilder: (child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        });
  }
}

class AnimatedTextField extends StatelessWidget {
  final TextEditingController searchQuery = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: searchBarStatusStream,
      initialData: false,
      builder: (context, snapshot) {
        return AnimatedPositioned(
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 1000),
          top: 10,
          left: snapshot.data ? 40 : MediaQuery.of(context).size.width / 2,
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 1000),
            height: 50,
            width: snapshot.data ? 220 : 0,
            child: Container(
              key: UniqueKey(),
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: searchQuery,
                keyboardType: TextInputType.text,
                onSubmitted: (_) {
                  print(_);
                  addEvent(context, searchQuery.text);
                },
                decoration: InputDecoration(
                  hintText: "search here!",
                  //filled: snapshot.data ? false : true,
                  //fillColor: Colors.yellowAccent,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
