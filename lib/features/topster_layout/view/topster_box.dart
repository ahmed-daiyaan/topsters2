import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';
import 'package:topsters/features/sliding_panel.dart/pages/search_page.dart';
import 'package:topsters/features/topster_layout/controller/topster_box_controller.dart';
import 'package:topsters/features/topster_layout/model/topster_box_model.dart';
import 'package:transparent_image/transparent_image.dart';

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
          return LayoutBuilder(builder: (context, constraints) {
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
                adaptiveHeight.add(constraints.maxHeight);
                return true;
              },
              onAccept: (data) {
                adaptiveHeight.add(95);
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
    final FadeInImage image = FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: boxData.image,
      fit: BoxFit.cover,
    );
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
        child: image);

    return GestureDetector(
      onDoubleTap: () => remove = true,
      child: LayoutBuilder(builder: (context, constraints) {
        return LongPressDraggable<TopsterBoxData>(
          feedback: StreamBuilder<double>(
              stream: adaptiveHeight,
              initialData: constraints.maxHeight,
              builder: (context, snapshot) {
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: snapshot.data,
                    width: snapshot.data,
                    child: image);
              }),
          data: boxData,
          childWhenDragging: image,
          onDragStarted: () {
            adaptiveHeight.add(constraints.maxHeight);
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
        );
      }),
    );
  }
}
