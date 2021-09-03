import 'flutter_exprtk_platform_interface.dart';

const String _not_supported_text = 'This platform is not supported!';

/// An implementation of [FlutterExprtkPlatform] that throws an [UnsupportedError] when attempting to call a method.
class FlutterExprtkPlatformUnsupported extends FlutterExprtkPlatform {
  @override
  int newExpression({required String expression, required Map<String, double> variables, Map<String, double>? constants}) {
    throw UnsupportedError(_not_supported_text);
  }

  @override
  toNativeUtf8(String string) {
    throw UnsupportedError(_not_supported_text);
  }

  @override
  clear(int pExpression) {
    throw UnsupportedError(_not_supported_text);
  }

  @override
  double getResult(int pExpression) {
    throw UnimplementedError();
  }

  @override
  int isValid(int pExpression) {
    throw UnimplementedError();
  }

  @override
  void setVar(int variableName, double variableValue, int pExpression) {
    throw UnimplementedError();
  }

  @override
  double getConst(int variableName, int pExpression) {
    throw UnimplementedError();
  }

  @override
  double getVar(int variableName, int pExpression) {
    throw UnimplementedError();
  }

  @override
  void setConst(int variableName, double variableValue, int pExpression) {
    throw UnimplementedError();
  }

  @override
  void free(int pointer) {
    throw UnimplementedError();
  }
}
