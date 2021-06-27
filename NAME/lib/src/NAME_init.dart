// Once all workarounds in workarounds/io.dart are fixed and removed, we
// should remove this!
import 'workarounds/web.dart' if (dart.library.io) 'workarounds/io.dart'
    as Workarounds;

void init() {
  Workarounds.apply();
}
