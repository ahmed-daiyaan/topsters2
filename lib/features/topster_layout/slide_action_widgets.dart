import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/layout_controller.dart';

class InsertAction extends StatefulWidget {
  const InsertAction({
    Key key,
    //@required this.insertRowStream,
    //@required this.layoutController,
    @required this.rowIndex,
    @required this.insertRow,
  }) : super(key: key);

  //final BehaviorSubject<int> insertRowStream;
  //final LayoutController layoutController;
  final int rowIndex;
  final Function insertRow;
  @override
  _InsertActionState createState() => _InsertActionState();
}

class _InsertActionState extends State<InsertAction> {
  int boxCount = 1;
  @override
  Widget build(BuildContext context) {
    return IconSlideAction(
      closeOnTap: false,
      iconWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: FittedBox(
                child: DropdownButton<int>(
              value: boxCount,
              onChanged: (rowCount) {
                setState(() {
                  boxCount = rowCount;
                });
              },
              items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
            )),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    child: FittedBox(
                        child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      widget.insertRow(widget.rowIndex, boxCount);
                    },
                  ),
                ))),
                Flexible(
                    child: FittedBox(
                        child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      widget.insertRow(widget.rowIndex + 1, boxCount);
                    },
                  ),
                ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReorderAction extends StatelessWidget {
  const ReorderAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IconSlideAction(
      caption: 'Reorder',
      color: Colors.pink,
      icon: Icons.compare_arrows,
    );
  }
}

class RemoveAction extends StatelessWidget {
  const RemoveAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IconSlideAction(
      caption: 'Remove',
      color: Colors.red,
      icon: Icons.cancel,
    );
  }
}

class TitleAction extends StatelessWidget {
  final int rowIndex;
  final LayoutController layoutController;
  final TextEditingController controller = TextEditingController();

  TitleAction({
    Key key,
    @required this.rowIndex,
    @required this.layoutController,
  }) : super(key: key);
  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter title'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.text.toString());
                },
                elevation: 5.0,
                child: const Text('Submit'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconSlideAction(
        onTap: () {
          createAlertDialog(context).then((enteredTitle) {
            layoutController.insertTitle(enteredTitle, rowIndex);
          });
        },
        iconWidget: Text(
          'Insert Title Above',
          textAlign: TextAlign.center,
          style:
              GoogleFonts.aBeeZee(fontSize: 12, color: const Color(0xFFEBEBEB)),
        ),
        icon: Icons.text_fields,
        //caption: 'T',
        color: Colors.blue);
  }
}
