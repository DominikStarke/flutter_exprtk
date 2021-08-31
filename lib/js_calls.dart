import 'dart:js' as js;

/// Static class holding the native function references
/// Note: This shouldn't be called manually
class WASMExpression {
  static js.JsObject _module = js.context['Module'];

  /// Whether the library has been initialized
  /// Note: This shouldn't be called manually
  static bool _initialized = false;

  /// Return a Pointer to a new native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction _newExpression;

  /// Parse given native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction _parseExpression;

  /// Destruct given native Expression, freeing memory
  /// Note: This shouldn't be called manually
  static late final js.JsFunction destructExpression;

  /// Return value from given native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction getResult;

  /// Set given variable for given native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction setVar;

  /// Set given const for given native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction setConst;

  /// Returns given variable from the native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction getVar;

  /// Returns given const from the native Expression
  /// Note: This shouldn't be called manually
  static late final js.JsFunction getConst;

  /// Checks whether given native Expression is valid
  /// Note: This shouldn't be called manually
  static late final js.JsFunction isValid;

  /// Initialize the native library
  /// Note: This shouldn't be called manually
  static init() {
    if (_initialized) return;

    _newExpression =
        _module.callMethod('cwrap', ['new_expression', 'number', js.JsArray.from(['number'])]);

    destructExpression = _module.callMethod('cwrap', [
      'destruct_expression',
      'void',
      js.JsArray.from(['number'])
    ]);

    _parseExpression = _module.callMethod('cwrap', [
      'parse_expression',
      'void',
      js.JsArray.from(['number'])
    ]);

    getResult = _module.callMethod('cwrap', [
      'get_result',
      'number',
      js.JsArray.from(['number'])
    ]);

    setVar = _module.callMethod('cwrap', [
      'set_var',
      'void',
      js.JsArray.from(['number', 'number'])
    ]);

    setConst = _module.callMethod('cwrap', [
      'set_const',
      'void',
      js.JsArray.from(['number', 'number'])
    ]);

    getVar = _module.callMethod('cwrap', [
      'get_var',
      'number',
      js.JsArray.from(['number', 'number'])
    ]);

    getConst = _module.callMethod('cwrap', [
      'get_const',
      'number',
      js.JsArray.from(['number', 'number'])
    ]);

    isValid = _module.callMethod('cwrap', [
      'is_valid',
      'number',
      js.JsArray.from(['number'])
    ]);

    _initialized = true;
  }

  /// Creates a new Expression instance in the native library
  /// Note: This shouldn't be called manually
  static int newExpression(
      {required String expression,
      required Map<String, double> variables,
      Map<String, double>? constants}) {
    final pExpression = _newExpression.apply([stringToCharArray(expression)]);

    variables
        .forEach((name, value) => setVar.apply([stringToCharArray(name), value, pExpression]));

    constants
        ?.forEach((name, value) => setConst.apply([stringToCharArray(name), value, pExpression]));

    _parseExpression.apply([pExpression]);

    return pExpression;
  }

  static int stringToCharArray(String str) {
    return _module["allocateUTF8OnStack"].apply(js.JsArray.from([str]));
  }
}
