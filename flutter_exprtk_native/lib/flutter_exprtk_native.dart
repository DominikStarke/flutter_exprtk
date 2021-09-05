import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';
import 'package:flutter_exprtk_native/defs.dart';

/// An implementation of [FlutterExprtkPlatform] for Windows.
class FlutterExprtkNative extends FlutterExprtkPlatform {
  /// Return a Pointer to a new native Expression
  /// Note: This shouldn't be called manually
  late final NewExpression _ffiNewExpression;

  /// Parse given native Expression
  /// Note: This shouldn't be called manually
  late final ParseExpression _ffiParseExpression;

  /// Destruct given native Expression, freeing memory
  /// Note: This shouldn't be called manually
  late final DestructExpression _ffiDestructExpression;

  /// Return value from given native Expression
  /// Note: This shouldn't be called manually
  late final GetValue _ffiGetResult;

  /// Set given variable for given native Expression
  /// Note: This shouldn't be called manually
  late final SetVarOrConst _ffiSetVar;

  /// Set given const for given native Expression
  /// Note: This shouldn't be called manually
  late final SetVarOrConst _ffiSetConst;

  /// Returns given variable from the native Expression
  /// Note: This shouldn't be called manually
  late final GetVarOrConst _ffiGetVar;

  /// Returns given const from the native Expression
  /// Note: This shouldn't be called manually
  late final GetVarOrConst _ffiGetConst;

  /// Checks whether given native Expression is valid
  /// Note: This shouldn't be called manually
  late final IsValid _ffiIsValid;

  FlutterExprtkNative() {
    final DynamicLibrary expressionLib = Platform.isAndroid
        ? DynamicLibrary.open("libflutter_exprtk_native.so")
        : Platform.isWindows
            ? DynamicLibrary.open("flutter_exprtk_native_plugin.dll")
            : DynamicLibrary.process();

    _ffiNewExpression = expressionLib
        .lookup<NativeFunction<NewExpressionImpl>>("new_expression")
        .asFunction();

    _ffiDestructExpression = expressionLib
        .lookup<NativeFunction<DestructExpressionImpl>>("destruct_expression")
        .asFunction();

    _ffiParseExpression = expressionLib
        .lookup<NativeFunction<ParseExpressionImpl>>("parse_expression")
        .asFunction();

    _ffiGetResult = expressionLib
        .lookup<NativeFunction<GetValueImpl>>("get_result")
        .asFunction();

    _ffiSetVar = expressionLib
        .lookup<NativeFunction<SetVarOrConstImpl>>("set_var")
        .asFunction();

    _ffiSetConst = expressionLib
        .lookup<NativeFunction<SetVarOrConstImpl>>("set_const")
        .asFunction();

    _ffiGetVar = expressionLib
        .lookup<NativeFunction<GetVarOrConstImpl>>("get_var")
        .asFunction();

    _ffiGetConst = expressionLib
        .lookup<NativeFunction<GetVarOrConstImpl>>("get_const")
        .asFunction();

    _ffiIsValid = expressionLib
        .lookup<NativeFunction<IsValidImpl>>("is_valid")
        .asFunction();
  }
  
  /// Registers the Windows implementation.
  static void registerWith() {
    FlutterExprtkPlatform.instance = new FlutterExprtkNative();
  }

  @override
  void clear(int pExpression) {
    _ffiDestructExpression(pExpression);
  }

  @override
  int newExpression({required String expression, required Map<String, double> variables, Map<String, double>? constants}) {
    final pExpression = _ffiNewExpression(toNativeUtf8(expression));

    variables.forEach(
        (name, value) => _ffiSetVar(toNativeUtf8(name), value, pExpression));

    constants?.forEach(
        (name, value) => _ffiSetConst(toNativeUtf8(name), value, pExpression));

    _ffiParseExpression(pExpression);

    return pExpression;
  }

  @override
  int toNativeUtf8(String string) {
    return string.toNativeUtf8().address;
  }

  @override
  double getConst(int variableName, int pExpression) {
    return _ffiGetConst(variableName, pExpression);
  }

  @override
  double getResult(int pExpression) {
    return _ffiGetResult(pExpression);
  }

  @override
  double getVar(int variableName, int pExpression) {
    return _ffiGetVar(variableName, pExpression);
  }

  @override
  int isValid(int pExpression) {
    return _ffiIsValid(pExpression);
  }

  @override
  void setConst(int variableName, double variableValue, int pExpression) {
    _ffiSetConst(variableName, variableValue, pExpression);
  }

  @override
  void setVar(int variableName, double variableValue, int pExpression) {
    _ffiSetVar(variableName, variableValue, pExpression);
  }

  @override
  void free(int ptr) {
    malloc.free(Pointer.fromAddress(ptr));
  }
}
