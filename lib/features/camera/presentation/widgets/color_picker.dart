import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    super.key,
    required this.onColorSelected,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int selectedColorIndex = 0;

  final List<Color> colorList = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      backgroundColor: Colors.transparent,
      itemExtent: 50, // Tamaño de cada elemento
      scrollController:
          FixedExtentScrollController(initialItem: selectedColorIndex),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedColorIndex = index;
        });
        widget.onColorSelected(colorList[index]);
      },
      children: colorList.map((color) {
        return Container(
          color: color,
          width: double.infinity,
        );
      }).toList(),
    );
  }
}
