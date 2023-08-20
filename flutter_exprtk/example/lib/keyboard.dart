import 'package:example/theme.dart';
import 'package:flutter/material.dart';

typedef OnPressFn = void Function(String);
typedef voidFn = void Function();

class CalculatorKeyboard extends StatelessWidget {
  final OnPressFn onPressed;
  final TextEditingController controller;
  final double spacing;
  
  CalculatorKeyboard({
    required this.onPressed,
    required this.controller,
    this.spacing = 1
  });

  late final List<Map<String, voidFn>> numbersButtonLayout = [
    {
      "7": () => onPressed("7"),
      "8": () => onPressed("8"),
      "9": () => onPressed("9"),
    },
    {
      "4": () => onPressed("4"),
      "5": () => onPressed("5"),
      "6": () => onPressed("6"),
    },
    {
      "1": () => onPressed("1"),
      "2": () => onPressed("2"),
      "3": () => onPressed("3"),
    },
    {
      "00": () => onPressed("00"),
      "0": () => onPressed("0"),
      ",": () => onPressed("."),
    }
  ];

  late final Map<String, voidFn> operatorsButtonLayout = {
    "÷": () => onPressed("/"),
    "x": () => onPressed("*"),
    "-": () => onPressed("-"),
    "+": () => onPressed("+"),
    "=": () => onPressed("="),
  };

  late final Map<String, voidFn> specialButtonLayout = {
    "C": () => onPressed("C"),
    "+/-": () => onPressed("*"),
    "%": () => onPressed("-"),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
    
              Theme(
                data: theme.specialButtonTheme,
                child: Row(
                  children: [
                    for(final input in specialButtonLayout.keys) Container(
                      margin: EdgeInsets.all(spacing),
                      width: 90,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: specialButtonLayout[input],
                        child: Text("${input}")
                      ),
                    ),
                  ],
                ),
              ),
    
              for(final row in numbersButtonLayout) Row(
                children: [
                  for(final input in row.keys) Container(
                    margin: EdgeInsets.all(spacing),
                    width: 90,
                    height: 50,
                    child: input == "" ? null : ElevatedButton(
                      onPressed: row[input],
                      child: Text("${input}")
                    ),
                  ),
                ],
              ),
            ]
          ),
    
          Theme(
            data: theme.operatorsButtonTheme,
            child: Column(
              children: [
                for(final input in operatorsButtonLayout.keys) Container(
                  margin: EdgeInsets.all(spacing),
                  width: 90,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: operatorsButtonLayout[input],
                    child: Text("${input}")
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}