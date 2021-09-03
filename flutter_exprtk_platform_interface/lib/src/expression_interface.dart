abstract class ExpressionInterface {
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
  ExpressionInterface(
      {required String expression,
      required Map<String, double> variables,
      Map<String, double>? constants});

  /// Returns the calculated value
  double get value;

  /// Set variable value
  operator []=(String variableName, double variableValue);

  /// Get variable value
  double operator [](String variableName);

  /// Free up memory
  void clear();
}