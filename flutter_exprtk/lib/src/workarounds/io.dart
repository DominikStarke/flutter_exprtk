import 'dart:io' show Platform;

import 'package:flutter_exprtk_native/flutter_exprtk_native.dart';
import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';

// A workaround for flutter/flutter#52267
// TODO: revise once the issue got resolved
void _flutterIssue52267Workaround() {
  if (Platform.isAndroid) {
    FlutterExprtkPlatform.instance = new FlutterExprtkNative();
  } else if (Platform.isIOS) {
    FlutterExprtkPlatform.instance = new FlutterExprtkNative();
  } else if (Platform.isMacOS) {
    FlutterExprtkPlatform.instance = new FlutterExprtkNative();
  }
}

// A workaround for flutter/flutter#81421
// TODO: revise once the issue got resolved
void _flutterIssue81421Workaround() {
  if (Platform.isWindows) {
    FlutterExprtkNative.registerWith();
  }
}

void apply() {
  _flutterIssue52267Workaround();
  _flutterIssue81421Workaround();
}
