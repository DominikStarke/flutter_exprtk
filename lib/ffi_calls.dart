
import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'dart:io';

typedef NewExpressionImpl = Pointer Function(Pointer<Utf8>);
typedef NewExpression = Pointer Function(Pointer<Utf8>);

typedef DestructExpressionImpl = Pointer Function(Pointer);
typedef DestructExpression = Pointer Function(Pointer);

typedef ParseExpressionImpl = Pointer Function(Pointer);
typedef ParseExpression = Pointer Function(Pointer);

typedef GetValueImpl = Float Function(Pointer);
typedef GetValue = double Function(Pointer);

typedef SetVarOrConstImpl = Void Function(Pointer<Utf8>, Double, Pointer);
typedef SetVarOrConst = void Function(Pointer<Utf8>, double, Pointer);

typedef GetVarOrConstImpl = Void Function(Pointer<Utf8>, Pointer);
typedef GetVarOrConst = void Function(Pointer<Utf8>, Pointer);

typedef IsValidImpl = Uint8 Function(Pointer);
typedef IsValid = int Function(Pointer);

class NativeExpression {
  static bool _initialized = false;
  static late final NewExpression _newExpression;
  static late final ParseExpression _parseExpression;
  static late final DestructExpression destructExpression;
  static late final GetValue getValue;
  static late final SetVarOrConst setVar;
  static late final SetVarOrConst setConst;
  static late final GetVarOrConst getVar;
  static late final GetVarOrConst getConst;
  static late final IsValid isValid;

  static init() {
    if(_initialized) return;

    final DynamicLibrary expressionLib = 
        Platform.isAndroid ? DynamicLibrary.open("libflutter_exprtk.so")
      : Platform.isWindows ? DynamicLibrary.open("flutter_exprtk_plugin.dll")
      : DynamicLibrary.process();

    _newExpression = expressionLib
      .lookup<NativeFunction<NewExpressionImpl>>("new_expression")
      .asFunction();

    destructExpression = expressionLib
      .lookup<NativeFunction<DestructExpressionImpl>>("destruct_expression")
      .asFunction();

    _parseExpression = expressionLib
      .lookup<NativeFunction<ParseExpressionImpl>>("parse_expression")
      .asFunction();

    getValue = expressionLib
      .lookup<NativeFunction<GetValueImpl>>("get_result")
      .asFunction();

    setVar = expressionLib
      .lookup<NativeFunction<SetVarOrConstImpl>>("set_var")
      .asFunction();

    setConst = expressionLib
      .lookup<NativeFunction<SetVarOrConstImpl>>("set_const")
      .asFunction();

    getVar = expressionLib
      .lookup<NativeFunction<GetVarOrConstImpl>>("get_var")
      .asFunction();

    getConst = expressionLib
      .lookup<NativeFunction<GetVarOrConstImpl>>("get_const")
      .asFunction();

    isValid = expressionLib
      .lookup<NativeFunction<IsValidImpl>>("is_valid")
      .asFunction();
    
    _initialized = true;
  }

  static Pointer newExpression({
    required String expression,
    required Map<String, double> variables,
    Map<String, double>? constants
  }) {
    final pExpression = _newExpression(expression.toNativeUtf8());

    variables.forEach((name, value) =>
      setVar(name.toNativeUtf8(), value, pExpression));

    constants?.forEach((name, value) =>
      setConst(name.toNativeUtf8(), value, pExpression));

    _parseExpression(pExpression);

    if(isValid(pExpression) == 1) {
      print(getValue(pExpression));
    } else {
      throw 'Invalid expression';
    }

    return pExpression;
  }

}
