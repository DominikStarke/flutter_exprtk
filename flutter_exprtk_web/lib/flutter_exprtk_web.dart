import 'dart:html';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';
import 'dart:js' as js;

/// An implementation of [FlutterExprtkPlatform] for web.
class FlutterExprtkWeb extends FlutterExprtkPlatform {
  late final js.JsObject _module;

  /// Return a Pointer to a new native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiNewExpression;

  /// Parse given native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiParseExpression;

  /// Destruct given native Expression, freeing memory
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiDestructExpression;

  /// Return value from given native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiGetResult;

  /// Set given variable for given native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiSetVar;

  /// Set given const for given native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiSetConst;

  /// Returns given variable from the native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiGetVar;

  /// Returns given const from the native Expression
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiGetConst;

  /// Checks whether given native Expression is valid
  /// Note: This shouldn't be called manually
  late final js.JsFunction _ffiIsValid;

  /// Free memory
  late final js.JsFunction _ffiFree;

  FlutterExprtkWeb() {
    asyncInit();
  }

  asyncInit() async {
    final script = window.document.createElement("script");
    final head = window.document.getElementsByTagName("head").first;
    script.setAttribute("src", "assets/packages/flutter_exprtk_web/assets/flutter_exprtk.js");
    head.append(script);

    script.addEventListener("load", (event) {
      _module = js.context['Module'];

      _ffiNewExpression = _module
        .callMethod('cwrap', ['new_expression', 'number', js.JsArray.from(['number'])]);

      _ffiDestructExpression = _module.callMethod('cwrap', [
        'destruct_expression',
        'void',
        js.JsArray.from(['number'])
      ]);

      _ffiParseExpression = _module.callMethod('cwrap', [
        'parse_expression',
        'void',
        js.JsArray.from(['number'])
      ]);

      _ffiGetResult = _module.callMethod('cwrap', [
        'get_result',
        'number',
        js.JsArray.from(['number'])
      ]);

      _ffiSetVar = _module.callMethod('cwrap', [
        'set_var',
        'void',
        js.JsArray.from(['number', 'number'])
      ]);

      _ffiSetConst = _module.callMethod('cwrap', [
        'set_const',
        'void',
        js.JsArray.from(['number', 'number'])
      ]);

      _ffiGetVar = _module.callMethod('cwrap', [
        'get_var',
        'number',
        js.JsArray.from(['number', 'number'])
      ]);

      _ffiGetConst = _module.callMethod('cwrap', [
        'get_const',
        'number',
        js.JsArray.from(['number', 'number'])
      ]);

      _ffiIsValid = _module.callMethod('cwrap', [
        'is_valid',
        'number',
        js.JsArray.from(['number'])
      ]);

      _ffiFree = _module.callMethod('cwrap', [
        'free',
        'void',
        js.JsArray.from(['number'])
      ]);
    });
  }

  @override
  void clear(int pExpression) {
    _ffiDestructExpression.apply([pExpression]);
  }

  @override
  int newExpression({required String expression, required Map<String, double> variables, Map<String, double>? constants}) {
    final pExpression = _ffiNewExpression.apply([toNativeUtf8(expression)]);

    variables
        .forEach((name, value) => _ffiSetVar.apply([toNativeUtf8(name), value, pExpression]));

    constants
        ?.forEach((name, value) => _ffiSetConst.apply([toNativeUtf8(name), value, pExpression]));

    _ffiParseExpression.apply([pExpression]);

    return pExpression;
  }

  @override
  int toNativeUtf8(String string) {
    return _module["allocateUTF8OnStack"].apply(js.JsArray.from([string]));
  }

  /// Registers the Windows implementation.
  static void registerWith(Registrar registrar) {
    FlutterExprtkPlatform.instance = new FlutterExprtkWeb();
  }

  @override
  double getResult(int pExpression) {
    return _ffiGetResult.apply([pExpression]);
  }

  @override
  int isValid(int pExpression) {
    return _ffiIsValid.apply([pExpression]);
  }

  @override
  void setVar(int variableName, double variableValue, int pExpression) {
    _ffiSetVar.apply([variableName, variableValue, pExpression]);
  }

  @override
  double getVar(int variableName, int pExpression) {
    return _ffiSetVar.apply([variableName, pExpression]);
  }

  @override
  void setConst(int variableName, double variableValue, int pExpression) {
    _ffiSetVar.apply([variableName, variableValue, pExpression]);
  }

  @override
  double getConst(int variableName, int pExpression) {
    return _ffiSetVar.apply([variableName, pExpression]);
  }

  @override
  void free(int ptr) {
    _ffiFree.apply([ptr]);
  }
}
