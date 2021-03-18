import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';
import 'package:topsters/features/sliding_panel.dart/pages/search_page.dart';
import 'package:topsters/features/sliding_panel.dart/widgets/design_tab.dart';
import 'package:topsters/features/sliding_panel.dart/widgets/search_tab.dart';
import 'package:topsters/features/topster_layout/controller/layout_controller.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/layout.dart';

class SlidingPanel extends StatefulWidget {
  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> {
  final PanelController panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LayoutController>(
              create: (context) => LayoutController()),
          ChangeNotifierProvider<TabChange>(create: (context) => TabChange()),
          ChangeNotifierProvider<Options>(create: (context) => Options()),
          ChangeNotifierProvider<TopsterBoxesController>(
            create: (context) =>
                TopsterBoxesController.initialize(totalBoxes: 40),
          ),
        ],
        child: SlidingUpPanel(
          maxHeight: 400,
          snapPoint: 0.3,
          controller: panelController,
          panelBuilder: (controller) {
            final PageController pageController = PageController();
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabStack(controller: pageController),
                  // Consumer<TabChange>(
                  //   builder: (context, tabChange, child) {
                  //     print('re');
                  //     return IndexedStack(
                  //         index: Provider.of<TabChange>(context, listen: false)
                  //                 .openTab
                  //             ? 0
                  //             : 1,
                  //         children: <Widget>[
                  //           SearchPage(
                  //             controller: controller,
                  //             panelController: panelController,
                  //           ),
                  //           DesignPage(),
                  //         ]);
                  //   },
                  // ),
                  Expanded(
                    child: PageView(
                      onPageChanged: (_) {},
                      controller: pageController,
                      children: [
                        SearchPage(
                          controller: controller,
                          panelController: panelController,
                        ),
                        DesignPage()
                      ],
                    ),
                  ),
                ]);
          },
          // ignore: prefer_const_constructors
          body: TopsterLayout(
            // ignore: prefer_const_literals_to_create_immutables
            rowsBoxCount: [5, 6, 6, 7, 7, 9],
          ),
        ));
  }
}

class TabStack extends StatelessWidget {
  const TabStack({
    Key key,
    this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width,
      child: Consumer<TabChange>(
        builder: (context, tabChange, child) {
          return Stack(
              fit: StackFit.expand,
              children: tabChange.openTab
                  ? [
                      DesignTab(controller: controller),
                      SearchTab(controller: controller)
                    ]
                  : [
                      SearchTab(controller: controller),
                      DesignTab(
                        controller: controller,
                      )
                    ]);
        },
      ),
    );
  }
}

class TabChange extends ChangeNotifier {
  bool openTab = true;

  void switchTabs() {
    openTab = !openTab;
    notifyListeners();
  }
}
