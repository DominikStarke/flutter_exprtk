import 'package:flutter_exprtk/js_calls.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_exprtk/flutter_exprtk.dart';

class FlutterExprtkWeb implements Expression {
  static void registerWith(Registrar registrar) {}
  late final int _pExpression;
  late final Map<String, int> _variableNames;

  final Map<String, double> _variables;
  final Map<String, double>? _constants;

  FlutterExprtkWeb(
      {required expression,
      required Map<String, double> variables,
      Map<String, double>? constants})
      : this._variables = variables,
        this._constants = constants {
    WASMExpression.init();
    _variableNames = variables.map((name, value) =>
        MapEntry(name, WASMExpression.stringToCharArray(name)));
    _pExpression = WASMExpression.newExpression(
        expression: expression, variables: _variables, constants: _constants);

    if (WASMExpression.isValid.apply([_pExpression]) == 0) {
      clear();
      throw InvalidExpressionException();
    }
  }

  @override
  void operator []=(String variableName, double variableValue) {
    final name = _variableNames[variableName];
    if (name != null) {
      WASMExpression.setVar.apply([name, variableValue, _pExpression]);
    } else {
      throw UninitializedVariableException();
    }
  }

  @override
  operator [](String variableName) {
    final name = _variableNames[variableName];
    if (name != null) {
      return WASMExpression.getVar.apply([name, _pExpression]);
    } else {
      throw UninitializedVariableException();
    }
  }

  @override
  clear() {
    WASMExpression.destructExpression.apply([_pExpression]);
  }

  @override
  double get value {
    return WASMExpression.getResult.apply([_pExpression]);
  } 
}

Expression getExpression(
        {required expression,
        required Map<String, double> variables,
        Map<String, double>? constants}) =>
    FlutterExprtkWeb(
        expression: expression, variables: variables, constants: constants);
