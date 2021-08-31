import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'dart:io';

/// Definition for Function lookup
/// see _newExpression
typedef NewExpressionImpl = Pointer Function(Pointer<Utf8>);

/// Definition for Function lookup
/// see _newExpression
typedef NewExpression = Pointer Function(Pointer<Utf8>);

/// Definition for Function lookup
/// see destructExpression
typedef DestructExpressionImpl = Pointer Function(Pointer);

/// Definition for Function lookup
/// see destructExpression
typedef DestructExpression = Pointer Function(Pointer);

/// Definition for Function lookup
/// see _parseExpression
typedef ParseExpressionImpl = Pointer Function(Pointer);

/// Definition for Function lookup
/// see _parseExpression
typedef ParseExpression = Pointer Function(Pointer);

/// Definition for Function lookup
/// see getValue
typedef GetValueImpl = Double Function(Pointer);

/// Definition for Function lookup
/// see getValue
typedef GetValue = double Function(Pointer);

/// Definition for Function lookup
/// see setVar and setConst
typedef SetVarOrConstImpl = Void Function(Pointer<Utf8>, Double, Pointer);

/// Definition for Function lookup
/// see setVar and setConst
typedef SetVarOrConst = void Function(Pointer<Utf8>, double, Pointer);

/// Definition for Function lookup
/// see getVar and getConst
typedef GetVarOrConstImpl = Void Function(Pointer<Utf8>, Pointer);

/// Definition for Function lookup
/// see getVar and getConst
typedef GetVarOrConst = void Function(Pointer<Utf8>, Pointer);

/// Definition for Function lookup
/// see isValid
typedef IsValidImpl = Uint8 Function(Pointer);

/// Definition for Function lookup
/// see isValid
typedef IsValid = int Function(Pointer);

/// Static class holding the native function references
/// Note: This shouldn't be called manually
class NativeExpression {
  /// Whether the library has been initialized
  /// Note: This shouldn't be called manually
  static bool _initialized = false;

  /// Return a Pointer to a new native Expression
  /// Note: This shouldn't be called manually
  static late final NewExpression _newExpression;

  /// Parse given native Expression
  /// Note: This shouldn't be called manually
  static late final ParseExpression _parseExpression;

  /// Destruct given native Expression, freeing memory
  /// Note: This shouldn't be called manually
  static late final DestructExpression destructExpression;

  /// Return value from given native Expression
  /// Note: This shouldn't be called manually
  static late final GetValue getResult;

  /// Set given variable for given native Expression
  /// Note: This shouldn't be called manually
  static late final SetVarOrConst setVar;

  /// Set given const for given native Expression
  /// Note: This shouldn't be called manually
  static late final SetVarOrConst setConst;

  /// Returns given variable from the native Expression
  /// Note: This shouldn't be called manually
  static late final GetVarOrConst getVar;

  /// Returns given const from the native Expression
  /// Note: This shouldn't be called manually
  static late final GetVarOrConst getConst;

  /// Checks whether given native Expression is valid
  /// Note: This shouldn't be called manually
  static late final IsValid isValid;

  /// Initialize the native library
  /// Note: This shouldn't be called manually
  static init() {
    if (_initialized) return;

    final DynamicLibrary expressionLib = Platform.isAndroid
        ? DynamicLibrary.open("libflutter_exprtk.so")
        : Platform.isWindows
            ? DynamicLibrary.open("flutter_exprtk_plugin.dll")
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

    getResult = expressionLib
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

  /// Creates a new Expression instance in the native library
  /// Note: This shouldn't be called manually
  static Pointer newExpression(
      {required String expression,
      required Map<String, double> variables,
      Map<String, double>? constants}) {
    final pExpression = _newExpression(expression.toNativeUtf8());

    variables.forEach(
        (name, value) => setVar(name.toNativeUtf8(), value, pExpression));

    constants?.forEach(
        (name, value) => setConst(name.toNativeUtf8(), value, pExpression));

    _parseExpression(pExpression);

    return pExpression;
  }
}
