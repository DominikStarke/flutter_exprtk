import 'package:flutter_exprtk/stub.dart'
    if (dart.library.io) 'package:flutter_exprtk/flutter_exprtk_ffi.dart'
    if (dart.library.html) 'package:flutter_exprtk/flutter_exprtk_web.dart';

class UninitializedVariableException implements Exception {
  String cause = "Cannot set an uninitialized variable";
}

class InvalidExpressionException implements Exception {
  String cause = "Invalid expression";
}

abstract class Expression {
  /// Returns the calculated value
  double get value;

  /// Set variable value
  operator []=(String variableName, double variableValue);

  /// Get variable value
  operator [](String variableName);

  /// Free up memory
  clear();

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
  factory Expression(
          {required expression,
          required Map<String, double> variables,
          Map<String, double>? constants}) =>
      getExpression(
          expression: expression, variables: variables, constants: constants);
}
