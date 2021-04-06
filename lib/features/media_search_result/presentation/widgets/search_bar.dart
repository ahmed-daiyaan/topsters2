import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

import '../bloc/search_results_bloc.dart';

BehaviorSubject<bool> searchBarStatusStream = BehaviorSubject<bool>();

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

void addEvent(BuildContext context, String searchQuery) {
  BlocProvider.of<SearchResultBloc>(context)
      .add(GetSearchResultForAlbum(searchQuery));
}

class _SearchBarState extends State<SearchBar> {
  // @override
  // void dispose() {
  //   searchBarStatusStream.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: ChangeNotifierProvider<SearchQueryController>(
            create: (context) => SearchQueryController(),
            builder: (context, child) {
              return Stack(children: <Widget>[
                AnimatedTextField(),
                AnimatedSearchIcon(),
              ]);
            }));
  }
}

class AnimatedSearchIcon extends StatelessWidget {
  final Widget circleAvatar = CircleAvatar(
    radius: 20,
    backgroundColor: const Color(0xFF050505),
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
              duration: const Duration(milliseconds: 500),
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
    return StreamBuilder<bool>(
        stream: searchBarStatusStream,
        initialData: false,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              duration: const Duration(milliseconds: 250),
              child: snapshot.data
                  ? ClearIcon(snapshot.data)
                  : SearchIcon(snapshot.data));
        });
    //);
  }
}

class AnimatedTextField extends StatefulWidget {
  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchQuery =
        Provider.of<SearchQueryController>(context, listen: false).searchQuery;
    final Widget textField = TextField(
      cursorHeight: 20,
      style: const TextStyle(fontSize: 14),
      textInputAction: TextInputAction.search,
      cursorColor: const Color(0xFF050505),
      controller: searchQuery,
      keyboardType: TextInputType.text,
      onSubmitted: (_) {
        searchBarStatusStream.add(false);
        addEvent(context, searchQuery.text);
      },
      decoration: const InputDecoration(
        hoverColor: Color(0xFF050505),
        isDense: true,
        prefixIcon: Icon(
          Icons.image_search_outlined,
          color: Color(0xFF050505),
        ),
        focusColor: Color(0xFF050505),
        focusedBorder: OutlineInputBorder(
          gapPadding: 2,
          borderSide: BorderSide(color: Color(0xFF050505)),
        ),
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050505)),
        ),
      ),
    );
    return StreamBuilder<bool>(
      stream: searchBarStatusStream,
      initialData: false,
      builder: (context, snapshot) {
        return Center(
          child: AnimatedContainer(
              curve: Curves.easeInOutCubic,
              duration: const Duration(milliseconds: 500),
              height: 30,
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
        splashRadius: 26,
        iconSize: 20,
        key: UniqueKey(),
        icon: const Icon(
          Icons.image_search_rounded,
          color: Color(0xFFEBEBEB),
        ),
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
    final TextEditingController searchQuery =
        Provider.of<SearchQueryController>(context, listen: false).searchQuery;
    return IconButton(
      splashRadius: 26,
      iconSize: 20,
      key: UniqueKey(),
      icon: const Icon(Icons.clear, color: Color(0xFFEBEBEB)),
      onPressed: () {
        searchQuery.clear();
        // status
        //     ? searchBarStatusStream.sink.add(!status)
        //     : searchBarStatusStream.sink.add(status);
      },
    );
  }
}

class SearchQueryController extends ChangeNotifier {
  final TextEditingController searchQuery = TextEditingController();
}
