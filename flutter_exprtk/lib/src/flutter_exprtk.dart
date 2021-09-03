library flutter_exprtk;

import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';
export 'package:flutter_exprtk/src/flutter_exprtk_init.dart';

import 'package:flutter_exprtk/src/exceptions.dart';
export 'package:flutter_exprtk/src/exceptions.dart';

class Expression extends ExpressionInterface {
  final Map<String, double> _variables;
  final Map<String, double>? _constants;

  late final Map<String, int> _variableNames;
  late final int _pExpression;

  /// Create a new math expression
  /// for example:
  /// ```
  /// final expression = Expression(
  ///   expression: "a / b",
  ///   variables: { "a": 4, "b": 2 }
  /// );
  /// print("${expression.value}"); // -> 4 / 2 = 2
  /// // Call clear to free up memory
  /// expression.clear();
  /// ```
  Expression(
      {required String expression,
      required Map<String, double> variables,
      Map<String, double>? constants})
      : this._variables = variables,
        this._constants = constants,
        super(expression: expression, variables: variables, constants: constants) {
    
    _variableNames =
        variables.map((name, value) => MapEntry(
          name, FlutterExprtkPlatform.instance.toNativeUtf8(name)));

    _pExpression = FlutterExprtkPlatform.instance.newExpression(
        expression: expression, variables: _variables, constants: _constants);

    if (FlutterExprtkPlatform.instance.isValid(_pExpression) == 0) {
      clear();
      throw InvalidExpressionException();
    }
  }

  /// Returns the calculated value
  get value => FlutterExprtkPlatform.instance.getResult(_pExpression);

  /// Set variable value
  operator []=(String variableName, double variableValue) {
    final name = _variableNames[variableName];
    if (name != null) {
      FlutterExprtkPlatform.instance.setVar(name, variableValue, _pExpression);
    } else {
      throw UninitializedVariableException();
    }
  }

  /// Get variable value
  operator [](String variableName) {
    final name = _variableNames[variableName];
    if (name != null) {
      return FlutterExprtkPlatform.instance.getVar(name, _pExpression);
    } else {
      throw UninitializedVariableException();
    }
  }

  /// Free up memory
  clear() {
    _variableNames.forEach((key, value) {
      FlutterExprtkPlatform.instance.clear(_pExpression);
    });
  }
}