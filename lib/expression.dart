
import 'package:ffi/ffi.dart';
import 'package:flutter_exprtk/ffi_calls.dart';
import 'dart:ffi';

class Expression {
  final String expression;
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
  Expression({
    required this.expression,
    required Map<String, double> variables,
    Map<String, double>? constants
  }) : this._variables = variables, this._constants = constants {
    _variableNames = variables.map((name, value)
      => MapEntry(name, name.toNativeUtf8()));

    NativeExpression.init();
    _pExpression = NativeExpression.newExpression(
      expression: expression,
      variables: _variables,
      constants: _constants
    );
  }

  /// Returns the calculated value
  get value => NativeExpression.getValue(_pExpression);

  /// Set variable value
  operator []=(String variableName, double variableValue) {
    final name = _variableNames[variableName];
    if(name != null) {
      NativeExpression.setVar(name, variableValue, _pExpression);
    } else {
      throw 'Cannot set uninitialized variable';
    }
  }

  /// Get variable value
  operator [](String variableName) {
    return NativeExpression.getVar(variableName.toNativeUtf8(), _pExpression);
  }

  /// Free up memory
  clear() {
    _variableNames.forEach((key, value) {
      malloc.free(value);
    });
    NativeExpression.destructExpression(_pExpression);
  }
}

