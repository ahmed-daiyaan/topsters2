import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/injection_container.dart';
import '../../domain/entities/search_results.dart';
import '../bloc/search_results_bloc.dart';
import '../widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool pressed = false;
  final PanelController controller = PanelController();
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(panel: Scaffold(body: buildBloc(context)));
  }
}

BlocProvider<SearchResultBloc> buildBloc(BuildContext context) {
  return BlocProvider<SearchResultBloc>(
    create: (_) => sl<SearchResultBloc>(),
    child: Column(
      children: <Widget>[
        Searchh(),
        BlocBuilder<SearchResultBloc, SearchResultState>(
            builder: (context, state) {
          if (state is Empty) {
            return Container(child: Text("None yet"));
          } else if (state is Loaded) {
            return ResultsDisplay(
              result: state.searchResult,
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ],
    ),
  );
}

class ResultsDisplay extends StatelessWidget {
  final ScrollController sc = ScrollController();
  final SearchResult result;
  ResultsDisplay({Key key, @required this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(controller: sc, slivers: <Widget>[
        // SliverAppBar(
        //     pinned: true,
        //     expandedHeight: 100,
        //     flexibleSpace: FlexibleSpaceBar(
        //       centerTitle: true,
        //       title: Searchh(),
        //     )
        //     //title: SliverToBoxAdapter(child: Searchh()),
        //     // leading: Searchh(),
        //     ),
        SliverList(
          delegate: SliverChildListDelegate([
            Center(child: Text("top result")),
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: result.mediaImages[0],
                imageScale: 2,
                //fit: BoxFit.scaleDown,
              ),
            ),
            Center(
                child: Text("other results:" + result.totalResults.toString()))
          ]),
        ),
        SliverGrid(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return AnimationConfiguration.staggeredGrid(
                columnCount: 2,
                position: index,
                delay: const Duration(seconds: 0),
                duration: const Duration(milliseconds: 400),
                child: ScaleAnimation(
                    child: GridTile(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: result.mediaImages[index],
                    fit: BoxFit.fill,
                  ),
                  header: Text(result.secondaryFields[index]),
                  footer: Text(result.mediaNames[index]),
                )));
          }, childCount: result.totalResults),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
        )
      ]),
    );
  }
}
