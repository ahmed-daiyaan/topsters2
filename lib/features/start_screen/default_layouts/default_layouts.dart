abstract class Layout {
  final String icon;
  final String name;

  Layout(this.icon, this.name);
}

abstract class DefaultLayout implements Layout {
  final List<int> rowsBoxCount;
  @override
  final String icon;
  @override
  final String name;
  final int totalBoxes;
  DefaultLayout(this.rowsBoxCount, this.icon, this.name, this.totalBoxes);
}

class LayoutTop100 implements DefaultLayout {
  @override
  final List<int> rowsBoxCount = [5, 5, 6, 6, 6, 10, 10, 10, 14, 14, 14];
  @override
  final String icon = "assets/100tilesname.png";
  @override
  final String name = "Top 100";
  @override
  final int totalBoxes = 100;
}

class LayoutTop42 implements DefaultLayout {
  @override
  final List<int> rowsBoxCount = [5, 5, 6, 6, 10, 10];
  @override
  final String icon = "assets/42tilesname.png";
  @override
  final String name = "Top 42";
  @override
  final int totalBoxes = 42;
}

class LayoutTop40 implements DefaultLayout {
  @override
  final List<int> rowsBoxCount = [5, 6, 6, 7, 7, 9];
  @override
  final String icon = "assets/40tilesname.png";
  @override
  final String name = "Top 40";
  @override
  final int totalBoxes = 40;
}
