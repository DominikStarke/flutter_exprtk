import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_exprtk_platform_interface/src/flutter_exprtk_platform_unsupported.dart';

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

  /// Creates a new Expression instance in the native library
  /// Note: This shouldn't be called manually
  int newExpression(
      {required String expression,
      required Map<String, double> variables,
      Map<String, double>? constants});

  /// Get a pointer to a char* array
  int toNativeUtf8(String string);

  /// Clear the expresseion
  void clear(int pExpression);

  /// Check whether an expression is valid
  int isValid(int pExpression);

  /// Get the result of an expresssion
  double getResult(int pExpression);

  /// Set variable variableName to variableValue
  void setVar(int variableName, double variableValue, int pExpression);

  /// Get the current value of the variable variableName
  double getVar(int variableName, int pExpression);

  /// Set the current value of the constant constantName
  void setConst(int constantName, double variableValue, int pExpression);

  /// Get the value of constant constantName
  double getConst(int constantName, int pExpression);
}

