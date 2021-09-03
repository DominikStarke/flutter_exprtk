import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_exprtk_platform_interface/src/flutter_exprtk_platform_unsupported.dart';

import 'package:flutter_exprtk_platform_interface/src/ffi_defs.dart'
  if (dart.library.html) 'package:flutter_exprtk_platform_interface/src/wasm_defs.dart';

/// The interface that implementations of flutter_exprtk must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_exprtk`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [FlutterExprtkPlatform] methods.
abstract class FlutterExprtkPlatform extends PlatformInterface {
  /// Constructs a FlutterExprtkPlatform.
  FlutterExprtkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterExprtkPlatform _instance = new FlutterExprtkPlatformUnsupported();

  /// The default instance of [FlutterExprtkPlatform] to use,
  /// defaults to [FlutterExprtkPlatformUnsupported].
  static FlutterExprtkPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterExprtkPlatform] when they register themselves.
  static set instance(FlutterExprtkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Return a Pointer to a new native Expression
  /// Note: This shouldn't be called manually
  late final NewExpression ffiNewExpression;

  /// Parse given native Expression
  /// Note: This shouldn't be called manually
  late final ParseExpression ffiParseExpression;

  /// Destruct given native Expression, freeing memory
  /// Note: This shouldn't be called manually
  late final DestructExpression ffiDestructExpression;

  /// Return value from given native Expression
  /// Note: This shouldn't be called manually
  late final GetValue ffiGetResult;

  /// Set given variable for given native Expression
  /// Note: This shouldn't be called manually
  late final SetVarOrConst ffiSetVar;

  /// Set given const for given native Expression
  /// Note: This shouldn't be called manually
  late final SetVarOrConst ffiSetConst;

  /// Returns given variable from the native Expression
  /// Note: This shouldn't be called manually
  late final GetVarOrConst ffiGetVar;

  /// Returns given const from the native Expression
  /// Note: This shouldn't be called manually
  late final GetVarOrConst ffiGetConst;

  /// Checks whether given native Expression is valid
  /// Note: This shouldn't be called manually
  late final IsValid ffiIsValid;

  /// Creates a new Expression instance in the native library
  /// Note: This shouldn't be called manually
  int newExpression(
      {required String expression,
      required Map<String, double> variables,
      Map<String, double>? constants});

  int toNativeUtf8(String string);

  void clear(int pExpression);

  int isValid(int pExpression);

  double getResult(int pExpression);

  void setVar(int variableName, double variableValue, int pExpression);

  double getVar(int variableName, int pExpression);

  void setConst(int variableName, double variableValue, int pExpression);

  double getConst(int variableName, int pExpression);
}

