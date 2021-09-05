class UninitializedVariableException implements Exception {
  String cause = "Cannot set an uninitialized variable";
}

class InvalidExpressionException implements Exception {
  String cause = "Invalid expression";
}

class ClearedExpressionException implements Exception {
  String cause = "Expression was cleared.";
}