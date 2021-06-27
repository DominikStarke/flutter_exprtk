import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'NAME_platform_unsupported.dart';

/// The interface that implementations of NAME must implement.
///
/// Platform implementations should extend this class rather than implement it as `NAME`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [CLASSPlatform] methods.
abstract class CLASSPlatform extends PlatformInterface {
  /// Constructs a CLASSPlatform.
  CLASSPlatform() : super(token: _token);

  static final Object _token = Object();

  static CLASSPlatform _instance = new CLASSPlatformUnsupported();

  /// The default instance of [CLASSPlatform] to use,
  /// defaults to [CLASSPlatformUnsupported].
  static CLASSPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CLASSPlatform] when they register themselves.
  static set instance(CLASSPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
