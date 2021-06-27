import 'package:NAME_platform_interface/NAME_platform_interface.dart';

/// An implementation of [CLASSPlatform] for Windows.
class CLASSWindows extends CLASSPlatform {
 
  /// Registers the Windows implementation.
  static void registerWith() {
    CLASSPlatform.instance = new CLASSWindows();
  }
}
