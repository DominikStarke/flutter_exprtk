// Once all workarounds in workarounds/io.dart are fixed and removed, we
// should remove this!
import 'workarounds/web.dart' if (dart.library.io) 'workarounds/io.dart'
    as Workarounds;

/// Registers the correct platform_interface for the current
/// platform.
///
/// Until flutter is able to do this automatically, this has
/// to be done manually. See the workarounds folder for more
/// details!

bool isInitialized = false;
void init() {
  if (isInitialized) return;
  isInitialized = true;
  Workarounds.apply();
}
