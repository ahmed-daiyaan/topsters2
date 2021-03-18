import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:topsters/features/topster_layout/model/topster_box_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/injection_container.dart';
import '../../media_search_result/domain/entities/search_results.dart';
import '../../media_search_result/presentation/bloc/search_results_bloc.dart';
import '../../media_search_result/presentation/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  const SearchPage({this.controller, this.panelController});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        color: Colors.pink,
        height: MediaQuery.of(context).size.height / 2,
        child: buildBloc(context));
  }

  BlocProvider<SearchResultBloc> buildBloc(BuildContext context) {
    return BlocProvider<SearchResultBloc>(
      create: (_) => sl<SearchResultBloc>(),
      child: BlocBuilder<SearchResultBloc, SearchResultState>(
          builder: (context, state) {
        if (state is Empty) {
          return Column(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 10,
                  width: 25,
                  color: Colors.grey,
                ),
              )),
              Searchh(),
            ],
          );
        } else if (state is Loaded) {
          return ResultsDisplay(
            result: state.searchResult,
            controller: widget.controller,
            panelController: widget.panelController,
          );
        } else {
          return const FittedBox(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ResultsDisplay extends StatelessWidget {
  final SearchResult result;
  final ScrollController controller;
  final PanelController panelController;
  const ResultsDisplay(
      {Key key, @required this.result, this.controller, this.panelController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: controller, slivers: [
      SliverToBoxAdapter(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 10,
            width: 25,
            color: Colors.grey,
          ),
        )),
      ),
      SliverAppBar(
        //centerTitle: true,
        //automaticallyImplyLeading: false,

        // leading: Icon(Icons.cancel, color: Colors.black,),
        titleSpacing: 0,
        stretch: true,
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Colors.white,

        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Searchh(),
        ),
        //pinned: true,
        floating: true,
      ),
      SliverList(
        delegate: SliverChildListDelegate.fixed([
          const Center(child: Text("top result")),
          Center(
              child: LongPressDraggable<TopsterBoxData>(
            feedback: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: result.mediaImages[0].toString(),
              imageScale: 2.0,
              //fit: BoxFit.fill,
            ),
            data: TopsterBoxData(
                image:
                    // Image.network(
                    result.mediaImages[0].toString(),
                // fit: BoxFit.fill,
                //),
                name: result.mediaNames[0].toString(),
                secondaryField: result.secondaryFields[0].toString()),
            onDragStarted: () {
              precacheImage(
                  NetworkImage(
                    result.mediaImages[0].toString(),
                    //fit: BoxFit.fill,
                  ),
                  context);
              panelController.close();
              controller.animateTo(0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut);
            },
            onDragEnd: (details) {
              //Future.delayed(Duration(seconds: 10));
              panelController.open();
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: result.mediaImages[0].toString(),
              imageScale: 2.0,
              //fit: BoxFit.fill,
            ),
          )),
          Center(child: Text("other results:${result.totalResults}")),
        ]),
      ),
      SliverGrid(
        //shrinkWrap: true,
        //controller: ScrollController(),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return
              /*AnimationConfiguration.staggeredGrid(
              columnCount: 2,
              position: index,
              duration: const Duration(milliseconds: 100),
              child: ScaleAnimation(
                  duration: const Duration(milliseconds: 100),
                  child: */
              GridTile(
            header: Text(result.secondaryFields[index].toString()),
            footer: Text(result.mediaNames[index].toString()),
            child: LongPressDraggable<TopsterBoxData>(
              feedback: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: result.mediaImages[index].toString(),
                imageScale: 2.0,
                //fit: BoxFit.fill,
              ),
              data: TopsterBoxData(
                  image:
                      //Image.network(
                      result.mediaImages[index].toString(),
                  //  fit: BoxFit.fill,
                  //),
                  name: result.mediaNames[index].toString(),
                  secondaryField: result.secondaryFields[index].toString()),
              onDragStarted: () {
                precacheImage(
                    NetworkImage(
                      result.mediaImages[index].toString(),
                      //fit: BoxFit.fill,
                    ),
                    context);
                panelController.close();
                controller.animateTo(0,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut);
              },
              onDragEnd: (details) {
                //Future.delayed(Duration(seconds: 10));
                panelController.open();
              },
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: result.mediaImages[index].toString(),
                imageScale: 2.0,
                //fit: BoxFit.fill,
              ),
            ),
            //))
          );
        }, childCount: result.totalResults),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
      )
    ]);
  }
}

class SearchTabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
