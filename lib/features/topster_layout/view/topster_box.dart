import 'package:flutter/material.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

import 'empty_box.dart';

class TopsterBox extends StatefulWidget {
  final int index;
  final double boxSize;
  final TopsterBoxesController controller;
  TopsterBox({this.index, this.controller, this.boxSize});

  @override
  _TopsterBoxState createState() => _TopsterBoxState();
}

class _TopsterBoxState extends State<TopsterBox> {
  bool insert = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<TopsterBoxData>(
      builder: (context, _, __) {
        return StreamBuilder<TopsterBoxData>(
            stream: widget.controller.boxStreams[widget.index],
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                insert = false;
                return const EmptyBox();
              } else {
                insert = true;
                return TDrag2(widget.index, snapshot.data, widget.controller,
                    widget.boxSize);
              }
            });
      },
      onWillAccept: (_) {
        return true;
      },
      onAccept: (data) {
        insert
            ? widget.controller.insertTopster(widget.index, data)
            : widget.controller.attachTopster(widget.index, data);
        print(widget.controller.topsterStore[widget.index].name);
        print(widget.index);
      },
    );
  }
}

class TDrag2 extends StatefulWidget {
  final int index;
  final TopsterBoxesController controller;
  final TopsterBoxData data;
  final double boxSize;

  TDrag2(this.index, this.data, this.controller, this.boxSize);
  @override
  _TDrag2State createState() => _TDrag2State();
}

class _TDrag2State extends State<TDrag2> {
  // @override
  // void dispose() {
  //   widget.controller.boxStreams.forEach((element) {
  //     element.close();
  //   });
  //   super.dispose();
  // }
  bool remove = false;
  @override
  Widget build(BuildContext context) {
    final Widget box = Container(
      child: widget.data.image,
      color: Colors.black,
      height: widget.boxSize,
      width: widget.boxSize,
    );
    return GestureDetector(
      onDoubleTap: () => remove = true,
      child: Draggable<TopsterBoxData>(
        feedback: box,
        child: box,
        data: widget.data,
        childWhenDragging: remove ? box : const EmptyBox(),
        onDragStarted: () {
          remove
              ? widget.controller.removeTopster(widget.index)
              : widget.controller.detachTopster(widget.index);
        },
        onDraggableCanceled: (_, __) {
          widget.controller.attachTopster(widget.index, widget.data);
        },
      ),
    );
  }
}
