import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';

import 'empty_box.dart';

class TopsterBox extends StatelessWidget {
  final int index;
  const TopsterBox({
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    bool insert = false;
    return Selector<TopsterBoxesController, TopsterBoxData>(
        selector: (context, controller) => controller.topsterStore[index],
        shouldRebuild: (previous, next) => previous != next,
        builder: (context, boxData, child) {
          return DragTarget<TopsterBoxData>(
            builder: (context, _, __) {
              if (boxData == null) {
                insert = false;
                return const EmptyBox();
              } else {
                insert = true;
                return TopsterDraggable(
                  index: index,
                  boxData: boxData,
                  controller: Provider.of<TopsterBoxesController>(context,
                      listen: false),
                );
              }
            },
            onWillAccept: (_) {
              return true;
            },
            onAccept: (data) {
              final controller =
                  Provider.of<TopsterBoxesController>(context, listen: false);
              insert
                  ? controller.insertUntilNullBox(index, data)
                  : controller.attachBox(index, data);

              debugPrint(
                  Provider.of<TopsterBoxesController>(context, listen: false)
                      .topsterStore[index]
                      .name);
              debugPrint(index.toString());
            },
          );
        });
  }
}

class TopsterDraggable extends StatelessWidget {
  final int index;
  final TopsterBoxesController controller;
  final TopsterBoxData boxData;

  const TopsterDraggable({
    this.index,
    this.boxData,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    bool remove = false;
    final Widget box = Consumer<Options>(
        builder: (context, opt, child) {
          return Container(
            decoration: BoxDecoration(
              color: opt.boxColor,
              border: Border.all(
                color: opt.boxBorderColor,
                width: opt.boxBorderSize,
              ),
              borderRadius: BorderRadius.circular(opt.boxBorderRadius),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(opt.boxBorderRadius),
                child: child),
          );
        },
        child: Image(
          image: NetworkImage(boxData.image),
          fit: BoxFit.cover,
        ));

    return GestureDetector(
      onDoubleTap: () => remove = true,
      child: LongPressDraggable<TopsterBoxData>(
        feedback: box,
        data: boxData,
        //childWhenDragging: remove ? box : const EmptyBox(),
        onDragStarted: () {
          if (remove) {
            controller.removeUntilNullBox(index);
            remove = false;
          } else {
            controller.detachBox(index);
          }
        },
        onDraggableCanceled: (_, __) {
          controller.attachBox(index, boxData);
        },
        child: box,
      ),
    );
  }
}
