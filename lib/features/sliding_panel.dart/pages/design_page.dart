import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:cyclop/cyclop.dart';
import 'package:topsters/features/save_topsters/data_to_json.dart';

class DesignPage extends StatefulWidget {
  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage>
    with AutomaticKeepAliveClientMixin {
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'hi', title: 'okay'),
    S2Choice<String>(value: 'hi', title: 'okay')
  ];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      controller: ScrollController(),
      shrinkWrap: true,
      children: [
        // SmartSelect<String>.single(
        //     modalType: S2ModalType.bottomSheet,
        //     choiceItems: options,
        //     title: 'color',
        //     value: 'hi',
        //     onChange: (n) => {}),
        //const SaveTopster(),
        const PaddingSlider(),
        BoxBorderRadiusSlider(),
        ChartBorderSizeSlider(),
        BoxBorderSlider(),
        BoxRadiusSlider(),
        //const ColorPicker()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// class ColorPicker extends StatelessWidget {
//   const ColorPicker({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ColorButton(
//       color: Provider.of<Options>(context, listen: false).boxBorderColor,
//       onColorChanged: (newColor) {
//         Provider.of<Options>(context, listen: false)
//             .changeBoxBorderColor(newColor);
//       },
//       size: 24,
//     );
//   }
// }

class BoxBorderSlider extends StatefulWidget {
  @override
  _BoxBorderSliderState createState() => _BoxBorderSliderState();
}

class _BoxBorderSliderState extends State<BoxBorderSlider> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    debugPrint(
        Provider.of<Options>(context, listen: false).boxBorderSize.toString());
    return Column(
      children: [
        const Text("Box Border Size"),
        Slider(
            max: 25.0,
            label: value.toString(),
            value: value,
            onChanged: (newValue) {
              setState(() {
                Provider.of<Options>(context, listen: false)
                    .changeBoxBorderSize(newValue);
                value = newValue;
              });
            }),
      ],
    );
  }
}

class BoxRadiusSlider extends StatefulWidget {
  @override
  _BoxRadiusSliderState createState() => _BoxRadiusSliderState();
}

class _BoxRadiusSliderState extends State<BoxRadiusSlider> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Box Radius"),
        Slider(
            max: 25.0,
            label: value.toString(),
            value: value,
            onChanged: (newValue) {
              setState(() {
                Provider.of<Options>(context, listen: false)
                    .changeBoxRadius(newValue);
                value = newValue;
              });
            }),
      ],
    );
  }
}

class PaddingSlider extends StatefulWidget {
  const PaddingSlider({
    Key key,
  }) : super(key: key);

  @override
  _PaddingSliderState createState() => _PaddingSliderState();
}

class _PaddingSliderState extends State<PaddingSlider> {
  double value = 1.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Padding",
        ),
        Slider(
            max: 25.0,
            label: value.toString(),
            value: value,
            onChanged: (newValue) {
              setState(() {
                Provider.of<Options>(context, listen: false)
                    .changeBoxPadding(newValue);
                value = newValue;
              });
            }),
      ],
    );
  }
}

//TODO: Dont let boxes go circle
class BoxBorderRadiusSlider extends StatefulWidget {
  @override
  _BoxBorderRadiusSliderState createState() => _BoxBorderRadiusSliderState();
}

class _BoxBorderRadiusSliderState extends State<BoxBorderRadiusSlider> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Rounded Corners"),
        Slider(
            max: 25.0,
            label: value.toString(),
            value: value,
            onChanged: (newValue) {
              setState(() {
                Provider.of<Options>(context, listen: false)
                    .changeBoxBorderRadius(newValue);
                value = newValue;
              });
            }),
      ],
    );
  }
}

class ChartBorderSizeSlider extends StatefulWidget {
  @override
  _ChartBorderSizeSliderState createState() => _ChartBorderSizeSliderState();
}

class _ChartBorderSizeSliderState extends State<ChartBorderSizeSlider> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Chart Border Size"),
        Slider(
            //min: 0.0,
            max: 25.0,
            label: value.toString(),
            value: value,
            onChanged: (newValue) {
              setState(() {
                Provider.of<Options>(context, listen: false)
                    .changeChartBorderSize(newValue);
                value = newValue;
              });
            }),
      ],
    );
  }
}

class Options extends ChangeNotifier {
  double boxPadding = 1.0;
  Color boxBorderColor = Colors.black;
  Color boxColor = const Color(0xFF050505);
  double boxBorderRadius = 0.0;
  double boxBorderSize = 0.0;
  double boxRadius = 0.0;
  double chartPadding = 10.0;
  double chartBorderRadius = 0.0;
  double chartBorderSize = 0.0;
  Color chartBorderColor = Colors.black;

  void changeBoxRadius(double newValue) {
    boxRadius = newValue;
    notifyListeners();
  }

  void changeChartPadding(double padding) {
    chartPadding = padding;
    notifyListeners();
  }

  void changeChartBorderRadius(double radius) {
    chartBorderRadius = radius;
    notifyListeners();
  }

  void changeChartBorderSize(double size) {
    chartBorderSize = size;
    notifyListeners();
  }

  void changeChartBorderColor(Color color) {
    chartBorderColor = color;
    notifyListeners();
  }

  void changeBoxBorderColor(Color color) {
    boxBorderColor = color;
    notifyListeners();
  }

  void changeBoxBorderSize(double size) {
    boxBorderSize = size;
    notifyListeners();
  }

  void changeBoxColor(Color color) {
    boxBorderColor = color;
    notifyListeners();
  }

  void changeBoxBorderRadius(double borderRadius) {
    boxBorderRadius = borderRadius;
    notifyListeners();
  }

  void changeBoxPadding(double padding) {
    boxPadding = padding;
    notifyListeners();
  }
}
