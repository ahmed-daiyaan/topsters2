import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:topsters/features/topster_layout/model/topster_box_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/injection_container.dart';
import '../../media_search_result/domain/entities/search_results.dart';
import '../../media_search_result/presentation/bloc/search_results_bloc.dart';
import '../../media_search_result/presentation/widgets/search_bar.dart';

BehaviorSubject<double> adaptiveHeight = BehaviorSubject<double>();

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
    return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: BlocProvider<SearchResultBloc>(
          create: (_) => sl<SearchResultBloc>(),
          child: BlocBuilder<SearchResultBloc, SearchResultState>(
              builder: (context, state) {
            return CustomScrollView(controller: widget.controller, slivers: [
              SliverAppBar(
                elevation: 1,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                stretch: true,
                centerTitle: true,
                toolbarHeight: 50,
                backgroundColor: Colors.white,

                title: Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                  child: SearchBar(),
                ),
                //pinned: true,
                floating: true,
              ),
              const SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.all(8))),
              if (state is Empty)
                const SliverToBoxAdapter(child: Text("Search"))
              else
                state is Loaded
                    ? ResultsDisplay(
                        result: state.searchResult,
                        controller: widget.controller,
                        panelController: widget.panelController,
                      )
                    : const SliverToBoxAdapter(
                        child: SpinKitCubeGrid(
                        size: 150,
                        color: Color(0xFF050505),
                      ))
            ]);
          }),
        ));
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
    searchBarStatusStream.add(true);
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final Widget image = FadeInImage.memoryNetwork(
          // height: snapshot.data,
          // width: snapshot.data,
          placeholder: kTransparentImage,
          image: result.mediaImages[index].toString(),
          //imageScale: 2.0,
          //fit: BoxFit.fill,
        );
        return
            // AnimationConfiguration.staggeredGrid(
            // columnCount: 2,
            // position: index,
            // duration: const Duration(milliseconds: 100),
            // child: ScaleAnimation(
            //     duration: const Duration(milliseconds: 100),
            //     child:
            Column(
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: LongPressDraggable<TopsterBoxData>(
                  childWhenDragging: image,
                  feedback: StreamBuilder<double>(
                      stream: adaptiveHeight,
                      initialData: 95,
                      builder: (context, snapshot) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: snapshot.data,
                            width: snapshot.data,
                            child: image);
                      }),
                  data: TopsterBoxData(
                      image: result.mediaImages[index].toString(),
                      name: result.mediaNames[index].toString(),
                      secondaryField: result.secondaryFields[index].toString()),
                  onDragStarted: () {
                    // precacheImage(
                    //     NetworkImage(
                    //       result.mediaImages[index].toString(),
                    //       //fit: BoxFit.fill,
                    //     ),
                    //     context);
                    panelController.close();
                    controller.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  onDragEnd: (details) {
                    adaptiveHeight.add(95);

                    panelController.open();
                  },
                  child: DraggableResult(image: image)
                  //child: image
                  ),
            ),
            const Padding(padding: EdgeInsets.all(2)),
            Flexible(
              child: Text(
                result.mediaNames[index].toString(),
                style: const TextStyle(
                  fontSize: 10,
                  //fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                result.secondaryFields[index].toString(),
                style: const TextStyle(
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        );
      }, childCount: result.totalResults),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
    );
  }
}

class DraggableResult extends StatelessWidget {
  const DraggableResult({
    Key key,
    @required this.image,
  }) : super(key: key);

  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image,
        Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) {
              return Positioned(
                  top: 3,
                  left: 3,
                  child: Container(
                      color: const Color(0xAAFFFFFF),
                      child: const Icon(
                        Icons.drag_handle,
                        size: 16,
                      )));
            }),
          ],
        ),
      ],
    );
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
