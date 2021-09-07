library flutter_exprtk;

import 'package:flutter_exprtk/flutter_exprtk.dart';
import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';
export 'package:flutter_exprtk/src/flutter_exprtk_init.dart';

import 'package:flutter_exprtk/src/exceptions.dart';
export 'package:flutter_exprtk/src/exceptions.dart';

class Expression extends ExpressionInterface {
  final Map<String, double> _stringCache;
  final Map<String, double>? _constants;

  late final Map<String, int> _variableNames;
  int _pExpression = 0;

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
      : this._stringCache = variables,
        this._constants = constants,
        super(
            expression: expression,
            variables: variables,
            constants: constants) {
    init();
    // Cache variable names, because toNativeUtf8 is slow
    _variableNames = variables.map((name, value) =>
        MapEntry(name, FlutterExprtkPlatform.instance.toNativeUtf8(name)));

    _pExpression = FlutterExprtkPlatform.instance.newExpression(
        expression: expression, variables: _stringCache, constants: _constants);

    if (FlutterExprtkPlatform.instance.isValid(_pExpression) == 0) {
      clear();
      throw InvalidExpressionException();
    }
  }

  /// Returns the calculated value
  get value {
    if (_pExpression == 0) throw ClearedExpressionException();
    return FlutterExprtkPlatform.instance.getResult(_pExpression);
  }

  /// Set variable value
  operator []=(String variableName, double variableValue) {
    if (_pExpression == 0) throw ClearedExpressionException();
    final pVariableName = _variableNames[variableName];
    if (pVariableName != null) {
      FlutterExprtkPlatform.instance
          .setVar(pVariableName, variableValue, _pExpression);
    } else {
      throw UninitializedVariableException();
    }
  }

  /// Get variable value
  operator [](String variableName) {
    if (_pExpression == 0) throw ClearedExpressionException();
    final pVariableName = _variableNames[variableName];
    if (pVariableName != null) {
      return FlutterExprtkPlatform.instance.getVar(pVariableName, _pExpression);
    } else {
      throw UninitializedVariableException();
    }
  }

  /// Free up memory
  clear() {
    if (_pExpression == 0) throw ClearedExpressionException();
    FlutterExprtkPlatform.instance.clear(_pExpression);
    _variableNames
        .forEach((key, ptr) => FlutterExprtkPlatform.instance.free(ptr));
    _pExpression = 0;
  }
}
