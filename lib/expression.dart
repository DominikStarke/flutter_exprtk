
import 'package:ffi/ffi.dart';
import 'package:flutter_exprtk/ffi_calls.dart';
import 'dart:ffi';

class Expression {
  final String expression;
  final Map<String, double> _variables;
  final Map<String, double>? _constants;

  late final Pointer<ExpressionStruct> _expression;

  /// Create a new math expression
  /// for example:
  /// ```
  /// final expression = Expression(
  ///   expression: "a / b",
  ///   variables: { "a": 4, "b": 2 }
  /// );
  /// print("${expression.value}"); // -> 4 / 2 = 2
  /// ```
  Expression({
    required this.expression,
    required Map<String, double> variables,
    Map<String, double>? constants
  }) : this._variables = variables, this._constants = constants {
    NativeExpression.init();
    _expression = NativeExpression.newExpression(
      expression: expression,
      variables: _variables,
      constants: _constants
    );
  }

  /// Returns the calculated value
  get value => NativeExpression.getValue(_expression);

  /// Set variable value
  operator []=(String variableName, double variableValue) {
    final numVariables = _expression.ref.numVariables!;
    for(int i = 0; i < numVariables; i++) {
      if(_expression.ref.variables!.elementAt(i).value.ref.name!.toDartString() == variableName) {
        _expression.ref.variables!.elementAt(i).value.ref.value = variableValue;
        return;
      }
    }
    throw 'Variable "$variableName" not found.';
  }

  /// Get variable value
  operator [](String variableName) {
    final numVariables = _expression.ref.numVariables!;
    for(int i = 0; i < numVariables; i++) {
      if(_expression.ref.variables!.elementAt(i).value.ref.name!.toDartString() == variableName) {
        return _expression.ref.variables!.elementAt(i).value.ref.value!;
      }
    }
    throw 'Variable "$variableName" not found.';
  }
}

