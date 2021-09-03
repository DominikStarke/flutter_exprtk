import 'dart:io' show Platform;

import 'package:flutter_exprtk_android/flutter_exprtk_android.dart';
import 'package:flutter_exprtk_ios/flutter_exprtk_ios.dart';
import 'package:flutter_exprtk_windows/flutter_exprtk_windows.dart';
import 'package:flutter_exprtk_platform_interface/flutter_exprtk_platform_interface.dart';

// A workaround for flutter/flutter#52267
// TODO: revise once the issue got resolved
void _flutterIssue52267Workaround() {
  if (Platform.isAndroid) {
    FlutterExprtkPlatform.instance = new FlutterExprtkAndroid();
  }
  if (Platform.isIOS) {
    FlutterExprtkPlatform.instance = new FlutterExprtkIOS();
  }
}

// A workaround for flutter/flutter#81421
// TODO: revise once the issue got resolved
void _flutterIssue81421Workaround() {
  if (Platform.isWindows) {
    FlutterExprtkWindows.registerWith();
  }
}

void apply() {
  _flutterIssue52267Workaround();
  _flutterIssue81421Workaround();
}
