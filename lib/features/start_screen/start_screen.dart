import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:topsters/features/sliding_panel.dart/panel/panel.dart';
import 'package:topsters/features/start_screen/default_layouts/default_layouts.dart';

import 'custom_layout/crazy_picker.dart';
import 'custom_layout/custom_picker.dart';
import 'custom_layout/grid_picker.dart';

class StartScreen extends StatefulWidget {
  List<DefaultLayout> get defaultlayouts =>
      [LayoutTop100(), LayoutTop42(), LayoutTop40()];
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DefaultTabController(
        length: 2,
        child: TabBar(
          controller: _controller,
          onTap: (int index) {
            _controller.animateTo(index);
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.add),
              text: "Create New",
            ),
            Tab(
              icon: Icon(Icons.upload_file),
              text: "Load Saved",
            ),
          ],
          indicatorColor: const Color(0xFFaa6124),
          unselectedLabelColor: const Color(0xFF474646),
          labelColor: const Color(0xFFebebeb),
          indicator: RectangularIndicator(
            bottomRightRadius: 5,
            bottomLeftRadius: 5,
            horizontalPadding: 5,
            verticalPadding: 5,
            color: const Color(0xFF050505),
          ),
        ),
      ),
      Expanded(
        child: TabBarView(controller: _controller, children: <Widget>[
          Column(
            //semanticChildCount: 2,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Start from a default layout",
                  style: TextStyle(color: Color(0xFF050505)),
                ),
              ),
              GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: List<Widget>.generate(widget.defaultlayouts.length,
                      (index) {
                    return LayoutIcon(
                      icon: widget.defaultlayouts[index].icon,
                      name: widget.defaultlayouts[index].name,
                      rowsBoxCount: widget.defaultlayouts[index].rowsBoxCount,
                      totalBoxes: widget.defaultlayouts[index].totalBoxes,
                    );
                  })),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("or make your own"),
              ),
              const LayoutIcon(
                icon: "assets/left-bars.png",
                name: "Custom",
              )
            ],
          ),
          GridView.count(crossAxisCount: 2)
        ]),
      )
    ]);
  }
}

class LayoutIcon extends StatelessWidget {
  final String icon;
  final String name;
  final List<int> rowsBoxCount;
  final int totalBoxes;
  const LayoutIcon({
    Key key,
    this.icon,
    this.name,
    this.rowsBoxCount,
    this.totalBoxes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return const Color(0x22050505);
        } else if (states.contains(MaterialState.hovered)) {
          return const Color(0x22050505);
        }
        return null;
      })),
      onPressed: () {
        if (name == "Custom") {
          setCustomLayout(context);
        } else {
          goToLayoutScreen(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: MediaQuery.of(context).size.width / 3 - 40,
            height: MediaQuery.of(context).size.width / 3 - 40,
          ),
          const SizedBox(height: 7),
          Text(
            name,
            style: GoogleFonts.aBeeZee(color: const Color(0xFF050505)),
          ),
        ],
      ),
    );
  }

  void goToLayoutScreen(BuildContext context) {
    Loader.show(context,
        progressIndicator: const SpinKitCubeGrid(
          size: 150,
          color: Color(0xFF050505),
        ));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SlidingPanel(
                  rowsBoxCount: rowsBoxCount,
                  totalBoxes: totalBoxes,
                )));
  }

  void setCustomLayout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const CustomDialog();
        });
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key key,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with TickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      color: const Color(0xFFEBEBEB),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          DefaultTabController(
            length: 3,
            child: TabBar(
              controller: _controller,
              onTap: (int index) {
                _controller.animateTo(
                  index,
                );
                // }
              },
              tabs: const [
                Tab(
                  icon: Icon(Icons.grid_on),
                  text: "Grid",
                ),
                Tab(
                  icon: Icon(Icons.dashboard_customize),
                  text: "Custom",
                ),
                Tab(
                  icon: Icon(Icons.format_paint),
                  text: "Crazy",
                ),
              ],
              indicatorColor: const Color(0xFFaa6124),
              unselectedLabelColor: const Color(0xFF474646),
              labelColor: const Color(0xFFebebeb),
              indicator: RectangularIndicator(
                bottomRightRadius: 5,
                bottomLeftRadius: 5,
                horizontalPadding: 5,
                verticalPadding: 5,
                color: const Color(0xFF050505),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(controller: _controller, children: const <Widget>[
              GridPicker(),
              CustomPicker(),
              CrazyPicker(),
            ]),
          )
        ]),
      ),
    );
  }
}
