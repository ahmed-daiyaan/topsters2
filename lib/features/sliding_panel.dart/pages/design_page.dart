import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
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
    return Container(
      //height: 300,
      color: Colors.pink,
      child: ListView(
        controller: ScrollController(),
        shrinkWrap: true,
        children: [
          SmartSelect<String>.single(
              modalType: S2ModalType.bottomSheet,
              choiceItems: options,
              title: 'color',
              value: 'hi',
              onChange: (n) => {}),
          const SaveTopster(),
          const PaddingSlider(),
          BorderRadiusSlider(),
          BorderSizeSlider()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    return Slider(
        min: 1.0,
        max: 25.0,
        label: value.toString(),
        value: value,
        onChanged: (newValue) {
          setState(() {
            Provider.of<Options>(context, listen: false)
                .changeBoxPadding(newValue);
            value = newValue;
          });
        });
  }
}

class BorderRadiusSlider extends StatefulWidget {
  @override
  _BorderRadiusSliderState createState() => _BorderRadiusSliderState();
}

class _BorderRadiusSliderState extends State<BorderRadiusSlider> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Slider(
        max: 25.0,
        label: value.toString(),
        value: value,
        onChanged: (newValue) {
          setState(() {
            Provider.of<Options>(context, listen: false)
                .changeBoxBorderRadius(newValue);
            value = newValue;
          });
        });
  }
}

class BorderSizeSlider extends StatefulWidget {
  @override
  _BorderSizeSliderState createState() => _BorderSizeSliderState();
}

class _BorderSizeSliderState extends State<BorderSizeSlider> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Slider(
        //min: 0.0,
        max: 25.0,
        label: value.toString(),
        value: value,
        onChanged: (newValue) {
          setState(() {
            Provider.of<Options>(context, listen: false)
                .changeBoxBorderSize(newValue);
            value = newValue;
          });
        });
  }
}

class Options extends ChangeNotifier {
  double boxPadding = 1.0;
  Color boxBorderColor = Colors.black;
  Color boxColor = Colors.red;
  double boxBorderRadius = 0.0;
  double boxBorderSize = 0.0;
  double chartPadding = 0.0;
  double chartBorderRadius = 0.0;
  double chartBorderSize = 0.0;
  Color chartBorderColor = Colors.black;

  // ignore: use_setters_to_change_properties
  void changeChartPadding(double padding) {
    chartPadding = padding;
  }

  // ignore: use_setters_to_change_properties
  void changeChartBorderRadius(double radius) {
    chartBorderRadius = radius;
  }

  // ignore: use_setters_to_change_properties
  void changeChartBorderSize(double size) {
    chartBorderSize = size;
  }

  // ignore: use_setters_to_change_properties
  void changeChartBorderColor(Color color) {
    chartBorderColor = color;
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
