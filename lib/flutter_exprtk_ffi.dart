import 'package:ffi/ffi.dart';
import 'package:flutter_exprtk/ffi_calls.dart';
import 'dart:ffi';

import 'package:flutter_exprtk/flutter_exprtk.dart';

class ExpressionFFI implements Expression {
  final String _expression;
  final Map<String, double> _variables;
  final Map<String, double>? _constants;

  late final Map<String, Pointer<Utf8>> _variableNames;
  late final Pointer _pExpression;

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
  ExpressionFFI(
      {required expression,
      required Map<String, double> variables,
      Map<String, double>? constants})
      : this._expression = expression,
        this._variables = variables,
        this._constants = constants {
    _variableNames =
        variables.map((name, value) => MapEntry(name, name.toNativeUtf8()));

    NativeExpression.init();
    _pExpression = NativeExpression.newExpression(
        expression: expression, variables: _variables, constants: _constants);

    if (NativeExpression.isValid(_pExpression) == 0) {
      clear();
      throw InvalidExpressionException();
    }
  }

  /// Returns the calculated value
  @override
  get value => NativeExpression.getResult(_pExpression);

  /// Set variable value
  @override
  operator []=(String variableName, double variableValue) {
    final name = _variableNames[variableName];
    if (name != null) {
      NativeExpression.setVar(name, variableValue, _pExpression);
    } else {
      throw UninitializedVariableException();
    }
  }

  /// Get variable value
  @override
  operator [](String variableName) {
    final name = _variableNames[variableName];
    if (name != null) {
      return NativeExpression.getVar(name, _pExpression);
    } else {
      throw UninitializedVariableException();
    }
  }

  /// Free up memory
  @override
  clear() {
    _variableNames.forEach((key, value) {
      malloc.free(value);
    });
    NativeExpression.destructExpression(_pExpression);
  }
}

Expression getExpression(
        {required expression,
        required Map<String, double> variables,
        Map<String, double>? constants}) =>
    ExpressionFFI(
        expression: expression, variables: variables, constants: constants);
