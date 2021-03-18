import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topsters/features/sliding_panel.dart/panel/panel.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({
    Key key,
    this.controller,
  }) : super(key: key);

  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      child: ClipPath(
        clipper: SearchTabClipper(),
        child: SearchTabContainer(controller: controller),
      ),
    );
  }
}

class SearchTabContainer extends StatelessWidget {
  const SearchTabContainer({
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
                  color: tabChange.openTab ? Colors.pink : Colors.grey),
              child: child);
        },
        child: SearchButton(controller: controller));
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (!Provider.of<TabChange>(context, listen: false).openTab) {
          Provider.of<TabChange>(context, listen: false).switchTabs();
          controller.jumpToPage(0);
        }
      },
      child: const Text('Search'),
    );
  }
}

class SearchTabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
