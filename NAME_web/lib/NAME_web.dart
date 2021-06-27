import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:NAME_platform_interface/NAME_platform_interface.dart';

/// An implementation of [CLASSPlatform] for web.
class CLASSWeb extends CLASSPlatform {
  static void registerWith(Registrar registrar) {
    CLASSPlatform.instance = new CLASSWeb();
  }
}
