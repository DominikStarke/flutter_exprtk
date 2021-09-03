import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';
import 'package:flutter_exprtk_platform_interface/src/ffi_defs.dart';

/// An implementation of [FlutterExprtkPlatform] for Windows.
class FlutterExprtkWindows extends FlutterExprtkPlatform {
  FlutterExprtkWindows() {
    final DynamicLibrary expressionLib = DynamicLibrary.open("flutter_exprtk_windows_plugin.dll");


    ffiNewExpression = expressionLib
        .lookup<NativeFunction<NewExpressionImpl>>("new_expression")
        .asFunction();

    ffiDestructExpression = expressionLib
        .lookup<NativeFunction<DestructExpressionImpl>>("destruct_expression")
        .asFunction();

    ffiParseExpression = expressionLib
        .lookup<NativeFunction<ParseExpressionImpl>>("parse_expression")
        .asFunction();

    ffiGetResult = expressionLib
        .lookup<NativeFunction<GetValueImpl>>("get_result")
        .asFunction();

    ffiSetVar = expressionLib
        .lookup<NativeFunction<SetVarOrConstImpl>>("set_var")
        .asFunction();

    ffiSetConst = expressionLib
        .lookup<NativeFunction<SetVarOrConstImpl>>("set_const")
        .asFunction();

    ffiGetVar = expressionLib
        .lookup<NativeFunction<GetVarOrConstImpl>>("get_var")
        .asFunction();

    ffiGetConst = expressionLib
        .lookup<NativeFunction<GetVarOrConstImpl>>("get_const")
        .asFunction();

    ffiIsValid = expressionLib
        .lookup<NativeFunction<IsValidImpl>>("is_valid")
        .asFunction();
  }
  
  /// Registers the Windows implementation.
  static void registerWith() {
    FlutterExprtkPlatform.instance = new FlutterExprtkWindows();
  }

  @override
  void clear(int pExpression) {
    ffiDestructExpression(pExpression);
  }

  @override
  int newExpression({required String expression, required Map<String, double> variables, Map<String, double>? constants}) {
    final pExpression = ffiNewExpression(toNativeUtf8(expression));

    variables.forEach(
        (name, value) => ffiSetVar(toNativeUtf8(name), value, pExpression));

    constants?.forEach(
        (name, value) => ffiSetConst(toNativeUtf8(name), value, pExpression));

    ffiParseExpression(pExpression);

    return pExpression;
  }

  @override
  int toNativeUtf8(String string) {
    return string.toNativeUtf8().address;
  }
}
