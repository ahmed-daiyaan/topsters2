import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';

import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

class DataToJson {
  List<TopsterBoxData> topsterData;
  List<int> layout;
  Options options;
  DataToJson({this.topsterData, this.layout, this.options});
  Map<String, dynamic> toJsonEncodable() {
    final Map<String, dynamic> m = //= Map<String, dynamic>();
        {
      'topsterBoxData': List.generate(topsterData.length, (index) {
        return {'name': null, 'secondaryField': null, 'imageUrl': null};
      }),
      'options': {
        'padding': '',
        'boxColor': '',
        'boxBorderColor': '',
        'borderRadius': '',
        'borderSize': ''
      },
      'layout': [0]
    };
    m['layout'] = layout;
    for (int i = 0; i < topsterData.length; i++) {
      try {
        m['topsterBoxData'][i]['name'] = topsterData[i].name;
        m['topsterBoxData'][i]['secondaryField'] =
            topsterData[i].secondaryField;
        m['topsterBoxData'][i]['imageUrl'] = topsterData[i].image;
      } catch (e) {
        m['topsterBoxData'][i]['name'] = null;
        m['topsterBoxData'][i]['secondaryField'] = null;
        m['topsterBoxData'][i]['imageUrl'] = null;
      }
    }

    m['options'] = {
      'boxPadding': options.boxPadding,
      'boxColor': options.boxColor.toString(),
      'boxBorderColor': options.boxBorderColor.toString(),
      'boxBorderRadius': options.boxBorderRadius,
      'boxBorderSize': options.boxBorderSize
    };

    return m;
  }
}

class SaveTopster extends StatefulWidget {
  const SaveTopster({Key key}) : super(key: key);

  @override
  _SaveTopsterState createState() => _SaveTopsterState();
}

class _SaveTopsterState extends State<SaveTopster> {
  final LocalStorage storage = LocalStorage('topster6');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            final List<int> layout = [3, 3, 3];
            //Provider.of<LayoutController>(context, listen: false)
            //     .rowsBoxCount;
            //print(layout);
            final topsterData =
                Provider.of<TopsterBoxesController>(context, listen: false)
                    .topsterStore;
            final options = Provider.of<Options>(context, listen: false);
            final DataToJson json = DataToJson(
                layout: layout, topsterData: topsterData, options: options);
            storage.setItem('topster6', json.toJsonEncodable());
          },
          child: const Text('save'),
        ),
        TextButton(
          onPressed: () {
            final s = storage.getItem('topster6');
            debugPrint(s.toString());
          },
          child: const Text('retrive'),
        ),
      ],
    );
  }
}
  // Future<Uint8List> _capturePng() async {
  //   try {
  //     print('inside');
  //     RenderRepaintBoundary boundary =
  //         _globalKey.currentContext.findRenderObject();
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     var pngBytes = byteData.buffer.asUint8List();
  //     var bs64 = base64Encode(pngBytes);
  //     print(pngBytes);
  //     print(bs64);
  //     setState(() {});
  //     return pngBytes;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
