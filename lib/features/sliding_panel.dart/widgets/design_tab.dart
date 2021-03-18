import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:topsters/features/sliding_panel.dart/panel/panel.dart';

class DesignTab extends StatelessWidget {
  const DesignTab({
    Key key,
    this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - 20,
      child: ClipPath(
        clipper: DesignTabClipper(),
        child: DesignTabContainer(controller: controller),
      ),
    );
  }
}

class DesignTabContainer extends StatelessWidget {
  const DesignTabContainer({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<TabChange>(
      builder: (context, tabChange, child) {
        return Container(
            height: 30,
            width: MediaQuery.of(context).size.width / 2 + 20,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: tabChange.openTab ? Colors.grey : Colors.pink),
            child: child);
      },
      child: DesignButton(controller: controller),
    );
  }
}

class DesignButton extends StatelessWidget {
  const DesignButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (Provider.of<TabChange>(context, listen: false).openTab) {
          controller.jumpToPage(1);

          Provider.of<TabChange>(context, listen: false).switchTabs();
        }
      },
      child: const Text('Design'),
    );
  }
}

class DesignTabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(20, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
