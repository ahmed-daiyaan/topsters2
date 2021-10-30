import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:topsters/features/sliding_panel.dart/pages/search_page.dart';

import 'package:topsters/features/topster_layout/controller/layout_controller.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/layout.dart';

class CreateLayout extends StatefulWidget {
  final List<int> rowsBoxCount;
  final int totalBoxes;
  const CreateLayout({Key key, this.rowsBoxCount, this.totalBoxes})
      : super(key: key);
  @override
  _CreateLayoutState createState() => _CreateLayoutState();
}

class _CreateLayoutState extends State<CreateLayout> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Options>(
            create: (context) => Options(),
          ),
          ChangeNotifierProvider<LayoutController>(
              create: (context) =>
                  LayoutController.initialize(widget.rowsBoxCount, context)),
          ChangeNotifierProvider<TopsterBoxesController>(
            create: (context) => TopsterBoxesController.initialize(
                totalBoxes: widget.totalBoxes),
          ),
        ],
        child: SlidingPanel(
            rowsBoxCount: widget.rowsBoxCount, totalBoxes: widget.totalBoxes));
  }
}

class SlidingPanel extends StatefulWidget {
  final List<int> rowsBoxCount;
  final int totalBoxes;
  const SlidingPanel({Key key, this.rowsBoxCount, this.totalBoxes})
      : super(key: key);
  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel>
    with TickerProviderStateMixin {
  final PanelController panelController = PanelController();
  int index = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Future.delayed(const Duration(milliseconds: 1500), () {
    //     Loader.hide();
    //   });
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Loader.hide();
    });
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiProvider(
      providers: [
        ChangeNotifierProvider<Options>(
          create: (context) => Options(),
        ),
        ChangeNotifierProvider<LayoutController>(
            create: (context) =>
                LayoutController.initialize(widget.rowsBoxCount, context)),
        ChangeNotifierProvider<TopsterBoxesController>(
          create: (context) =>
              TopsterBoxesController.initialize(totalBoxes: widget.totalBoxes),
        ),
      ],
      child: SlidingUpPanel(
          maxHeight: 400,
          //snapPoint: 0.3,
          controller: panelController,
          panelBuilder: (controller) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTabController(
                    length: 2,
                    child: SizedBox(
                      height: 50,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        labelStyle: const TextStyle(fontSize: 12),
                        controller: tabController,
                        onTap: (int index) {
                          tabController.animateTo(index);
                        },
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.search, size: 16),
                            text: "Search",
                          ),
                          Tab(
                            icon: Icon(Icons.format_paint, size: 16),
                            text: "Design",
                          ),
                        ],
                        indicatorColor: const Color(0xFFaa6124),
                        unselectedLabelColor: const Color(0xFF474646),
                        labelColor: const Color(0xFFebebeb),
                        indicator: RectangularIndicator(
                          bottomRightRadius: 5,
                          bottomLeftRadius: 5,
                          horizontalPadding: 10,
                          verticalPadding: 2,
                          color: const Color(0xFF050505),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          SearchPage(
                              controller: controller,
                              panelController: panelController),
                          DesignPage()
                        ]),
                  )
                ]);
          },
          // ignore: prefer_const_constructors
          body: TopsterLayout(
            // ignore: prefer_const_literals_to_create_immutables
            rowsBoxCount: widget.rowsBoxCount,
          )),
    ));
  }
}
