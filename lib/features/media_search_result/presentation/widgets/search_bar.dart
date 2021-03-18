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
  // @override
  // void dispose() {
  //   searchBarStatusStream.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: <Widget>[
          AnimatedTextField(),
          AnimatedSearchIcon(),
        ]));
  }
}

class AnimatedSearchIcon extends StatelessWidget {
  final Widget circleAvatar = CircleAvatar(
    radius: 20,
    backgroundColor: Colors.blue,
    child: AnimatedIconSwitcher(),
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: searchBarStatusStream,
        initialData: false,
        builder: (context, snapshot) {
          return AnimatedPositioned(
              top: 3.5,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOutCubic,
              left: snapshot.data
                  ? MediaQuery.of(context).size.width -
                      (MediaQuery.of(context).size.width / 10 +
                          MediaQuery.of(context).size.width / 10)
                  : MediaQuery.of(context).size.width / 2 - 20,
              child: circleAvatar);
        });
  }
}

class AnimatedIconSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: StreamBuilder<bool>(
          stream: searchBarStatusStream,
          initialData: false,
          builder: (context, snapshot) {
            return snapshot.data
                ? ClearIcon(snapshot.data)
                : SearchIcon(snapshot.data);
          }),
    );
  }
}

class AnimatedTextField extends StatelessWidget {
  final TextEditingController searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Widget textField = TextField(
      controller: searchQuery,
      keyboardType: TextInputType.text,
      onSubmitted: (_) {
        debugPrint(_);
        addEvent(context, searchQuery.text);
      },
      decoration: InputDecoration(
        hintText: "search here!",
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(100)),
      ),
    );
    return StreamBuilder<bool>(
      stream: searchBarStatusStream,
      initialData: false,
      builder: (context, snapshot) {
        return Center(
          child: AnimatedContainer(
              curve: Curves.easeInOutCubic,
              duration: const Duration(milliseconds: 1000),
              height: 50,
              width: snapshot.data
                  ? MediaQuery.of(context).size.width -
                      (MediaQuery.of(context).size.width / 10 +
                          MediaQuery.of(context).size.width / 10)
                  : 0,
              child: textField),
        );
      },
    );
  }
}

class SearchIcon extends StatelessWidget {
  final bool status;

  // ignore: avoid_positional_boolean_parameters
  const SearchIcon(this.status);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 20,
        key: UniqueKey(),
        icon: const Icon(Icons.search),
        onPressed: () {
          !status
              ? searchBarStatusStream.sink.add(!status)
              : searchBarStatusStream.sink.add(status);
        });
  }
}

class ClearIcon extends StatelessWidget {
  final bool status;

  // ignore: avoid_positional_boolean_parameters
  const ClearIcon(this.status);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      key: UniqueKey(),
      icon: const Icon(Icons.clear),
      onPressed: () {
        status
            ? searchBarStatusStream.sink.add(!status)
            : searchBarStatusStream.sink.add(status);
      },
    );
  }
}
