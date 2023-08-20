import 'package:example/keyboard.dart';
import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exprtk/flutter_exprtk.dart';

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final TextEditingController inputController = TextEditingController();

  void calculate() {
    try {
      final exp2 = Expression(
        expression: inputController.text,
        variables: {}
      );
      inputController.text = exp2.value.toString();
      exp2.clear();
    } catch (e) {
      print(e.runtimeType);
    }
  }

  void onInput(String input) {
    if(input == "=") {
      calculate();
      return;
    } else if(input == "C") {
      inputController.text = "";
    } else {
      final a = inputController.text.substring(0, inputController.selection.start);
      final b = inputController.text.substring(inputController.selection.end, inputController.text.length);
      inputController.text = "$a$input$b";
      inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: a.length + input.length)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFieldTapRegion(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: double.infinity, height: double.infinity
              ),
              child: TextField(
                autofocus: true,
                style: theme.primaryTextInputStyle,
                decoration: theme.primaryTextInputDecoration,
                controller: inputController,
                keyboardType: TextInputType.none,
                expands: true,
                maxLines: null,
              ),
            )
          ),
    
          Container(
            color: theme.colorScheme.surface,
            child: CalculatorKeyboard(
              onPressed: onInput,
              controller: inputController
            ),
          ),
        ],
      ),
    );
  }
}