import 'dart:async';
import 'dart:html';
import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';
import 'dart:js' as js;

/// An implementation of [FlutterExprtkPlatform] for web.
class FlutterExprtkWeb extends FlutterExprtkPlatform {
  late final js.JsObject _module;

  FlutterExprtkWeb() {
    asyncInit();
  }

  asyncInit() async {
    final script = window.document.createElement("script");
    final head = window.document.getElementsByTagName("head").first;
    script.setAttribute("src", "assets/packages/flutter_exprtk_web/assets/flutter_exprtk.js");
    head.append(script);

    script.addEventListener("load", (event) {
      print("EVENT $event");
      _module = js.context['Module'];

      ffiNewExpression = _module
        .callMethod('cwrap', ['new_expression', 'number', js.JsArray.from(['number'])]);

      ffiDestructExpression = _module.callMethod('cwrap', [
        'destruct_expression',
        'void',
        js.JsArray.from(['number'])
      ]);

      ffiParseExpression = _module.callMethod('cwrap', [
        'parse_expression',
        'void',
        js.JsArray.from(['number'])
      ]);

      ffiGetResult = _module.callMethod('cwrap', [
        'get_result',
        'number',
        js.JsArray.from(['number'])
      ]);

      ffiSetVar = _module.callMethod('cwrap', [
        'set_var',
        'void',
        js.JsArray.from(['number', 'number'])
      ]);

      ffiSetConst = _module.callMethod('cwrap', [
        'set_const',
        'void',
        js.JsArray.from(['number', 'number'])
      ]);

      ffiGetVar = _module.callMethod('cwrap', [
        'get_var',
        'number',
        js.JsArray.from(['number', 'number'])
      ]);

      ffiGetConst = _module.callMethod('cwrap', [
        'get_const',
        'number',
        js.JsArray.from(['number', 'number'])
      ]);

      ffiIsValid = _module.callMethod('cwrap', [
        'is_valid',
        'number',
        js.JsArray.from(['number'])
      ]);
    });
  }

  @override
  void clear(int pExpression) {
    // TODO: implement clear
  }

  @override
  int newExpression({required String expression, required Map<String, double> variables, Map<String, double>? constants}) {
    final pExpression = ffiNewExpression.apply([toNativeUtf8(expression)]);

    variables
        .forEach((name, value) => ffiSetVar.apply([toNativeUtf8(name), value, pExpression]));

    constants
        ?.forEach((name, value) => ffiSetConst.apply([toNativeUtf8(name), value, pExpression]));

    ffiParseExpression.apply([pExpression]);

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

  Future<ByteData> loadAsset (String resource) async {
    return await rootBundle.load(resource);
  }

  Future<void> loadJS () async {
      // final moduleLoader = await rootBundle.loadString("packages/flutter_exprtk_web/assets/flutter_exprtk.js", );
  }

  @override
  double getResult(int pExpression) {
    return ffiGetResult.apply([pExpression]);
  }

  @override
  int isValid(int pExpression) {
    return ffiIsValid.apply([pExpression]);
  }

  @override
  void setVar(int variableName, double variableValue, int pExpression) {
    ffiSetVar.apply([variableName, variableValue, pExpression]);
  }

  @override
  double getVar(int variableName, int pExpression) {
    return ffiSetVar.apply([variableName, pExpression]);
  }

  @override
  void setConst(int variableName, double variableValue, int pExpression) {
    ffiSetVar.apply([variableName, variableValue, pExpression]);
  }

  @override
  double getConst(int variableName, int pExpression) {
    return ffiSetVar.apply([variableName, pExpression]);
  }
}
