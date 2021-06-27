import 'dart:io' show Platform;

import 'package:NAME_android/NAME_android.dart';
import 'package:NAME_ios/NAME_ios.dart';
import 'package:NAME_windows/NAME_windows.dart';
import 'package:NAME_platform_interface/NAME_platform_interface.dart';

// A workaround for flutter/flutter#52267
// TODO: revise once the issue got resolved
void _flutterIssue52267Workaround() {
  if (Platform.isAndroid) {
    CLASSPlatform.instance = new CLASSAndroid();
  }
  if (Platform.isIOS) {
    CLASSPlatform.instance = new CLASSIOS();
  }
}

// A workaround for flutter/flutter#81421
// TODO: revise once the issue got resolved
void _flutterIssue81421Workaround() {
  if (Platform.isWindows) {
    CLASSWindows.registerWith();
  }
}

void apply() {
  _flutterIssue52267Workaround();
  _flutterIssue81421Workaround();
}
