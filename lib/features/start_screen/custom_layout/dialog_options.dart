import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:topsters/features/sliding_panel.dart/panel/panel.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DialogOptions extends StatelessWidget {
  final List<int> rowsBoxCount;
  const DialogOptions({
    Key key,
    this.rowsBoxCount,
  }) : super(key: key);
  int calculateTotalBoxes() {
    final int totalBoxes = rowsBoxCount.fold<int>(
        0, (previousValue, element) => previousValue + element);
    return totalBoxes;
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedButton(
          //borderRadius: 5,
          width: 60,
          height: 25,
          textStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF050505),
              fontWeight: FontWeight.bold),
          isReverse: true,
          selectedTextColor: const Color(0xFFebebeb),
          selectedBackgroundColor: const Color(0xFF050505),
          backgroundColor: const Color(0xFFebebeb),
          text: "Create",
          //borderRadius: 20,
          borderColor: const Color(0xFF050505),
          onPress: () {
            Loader.show(context,
                progressIndicator: const SpinKitCubeGrid(
                  size: 150,
                  color: Color(0xFF050505),
                ));
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SlidingPanel(
                          rowsBoxCount: rowsBoxCount,
                          totalBoxes: calculateTotalBoxes())));
            });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedButton(
          //borderRadius: 5,
          animationDuration: const Duration(milliseconds: 150),
          width: 60,
          height: 25,
          textStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF050505),
              fontWeight: FontWeight.bold),
          isReverse: true,
          selectedTextColor: const Color(0xFFebebeb),
          selectedBackgroundColor: const Color(0xFF050505),
          backgroundColor: const Color(0xFFebebeb),
          text: "Go Back",
          //borderRadius: 20,
          borderColor: const Color(0xFF050505),
          onPress: () {
            Future.delayed(const Duration(milliseconds: 150), () {
              Navigator.pop(context);
            });
          },
        ),
      ),
    ]);
  }
}
