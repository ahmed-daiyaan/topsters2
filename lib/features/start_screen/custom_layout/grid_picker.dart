import 'package:flutter/material.dart';

import 'dialog_options.dart';

class GridPicker extends StatefulWidget {
  const GridPicker({
    Key key,
  }) : super(key: key);

  @override
  _GridPickerState createState() => _GridPickerState();
}

class _GridPickerState extends State<GridPicker> {
  double value = 3;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Select your grid size",
            style: TextStyle(color: Color(0xFF050505), fontSize: 18),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
            child: Column(
              children: [
                Slider(
                  activeColor: const Color(0xFF050505),
                  inactiveColor: const Color(0xFFEBEBEB),
                  label: "${value.round()} x ${value.round()}",
                  divisions: 20,
                  min: 1,
                  max: 20,
                  value: value,
                  onChanged: (val) {
                    setState(() {
                      value = val.round().toDouble();
                    });
                  },
                ),
                GridSelectView(value: value),
                DialogOptions(
                  rowsBoxCount:
                      List.generate(value.round(), (index) => value.round()),
                )
              ],
            )),
      ],
    );
  }
}

class GridSelectView extends StatelessWidget {
  const GridSelectView({
    Key key,
    @required this.value,
  }) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 220,
        width: 220,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: value.round(),
              mainAxisSpacing: 3,
              crossAxisSpacing: 3),
          itemCount: value.round() * value.round(), //shrinkWrap: true,

          itemBuilder: (context, index) =>
              Container(color: const Color(0xFF050505)),
        ),
      ),
    );
  }
}
