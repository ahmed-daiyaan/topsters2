import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';
import 'package:topsters/features/topster_layout/view/topster_box.dart';

class TopsterGridRow extends StatelessWidget {
  const TopsterGridRow(
      {Key key,
      @required this.count,
      @required this.rowsBoxCount,
      @required this.rowIndex})
      : super(key: key);

  final int count;

  final List<int> rowsBoxCount;
  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: count,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //childAspectRatio: 0.8,
              crossAxisCount: count,
            ),
            itemBuilder: (context, boxCountIndex) => Consumer<Options>(
                builder: (context, opt, child) {
                  return Padding(
                      padding: EdgeInsets.all(opt.boxPadding),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(opt.boxBorderRadius),
                            border: opt.boxBorderSize == 0.0
                                ? Border.all()
                                : Border.all(
                                    width: opt.boxBorderSize,
                                    color: opt.boxBorderColor),
                          ),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(opt.boxRadius),
                              child: child)));
                },
                child: TopsterBox(
                    index: calculateBoxIndex(
                  rowIndex,
                  boxCountIndex,
                )))),
      ],
    );
  }

  int calculateBoxIndex(int columnIndex, int rowIndex) {
    final boxIndex = rowsBoxCount
            .sublist(0, columnIndex)
            .fold<int>(0, (prev, element) => prev + element) +
        rowIndex;
    return boxIndex;
  }
}
