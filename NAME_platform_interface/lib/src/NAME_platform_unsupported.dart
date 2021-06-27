import 'NAME_platform_interface.dart';

const String _not_supported_text='This platform is not supported!';

/// An implementation of [CLASSPlatform] that throws an [UnsupportedError] when attempting to call a method.
class CLASSPlatformUnsupported extends CLASSPlatform {

  /// Always throws an [UnsupportedError].
  every method() {
    throw new UnsupportedError(_not_supported_text);
  }
}