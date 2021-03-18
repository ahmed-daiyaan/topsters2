import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/pages/design_page.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox();
  @override
  Widget build(BuildContext context) {
    return Consumer<Options>(
        builder: (context, value, child) => Container(
              decoration: BoxDecoration(
                color: value.boxColor,
                borderRadius: BorderRadius.circular(value.boxBorderRadius),
                border: Border.all(
                  color: value.boxBorderColor,
                  width: value.boxBorderSize,
                ),
              ),
            ));
  }
}
