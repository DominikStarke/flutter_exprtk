import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';

/// An implementation of [FlutterExprtkPlatform] for Android.
class FlutterExprtkAndroid extends FlutterExprtkPlatform {
  @override
  void clear(int pExpression) {
    // TODO: implement clear
  }

  @override
  int newExpression({required String expression, required Map<String, double> variables, Map<String, double>? constants}) {
    // TODO: implement newExpression
    throw UnimplementedError();
  }

  @override
  int toNativeUtf8(String string) {
    // TODO: implement toNativeUtf8
    throw UnimplementedError();
  }

    /// Registers the Windows implementation.
  static void registerWith() {
    FlutterExprtkPlatform.instance = new FlutterExprtkAndroid();
  }
}
