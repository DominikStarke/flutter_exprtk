#import "NativeMidiPlugin.h"
#if __has_include(<flutter_exprtk/flutter_exprtk-Swift.h>)
#import <flutter_exprtk/flutter_exprtk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_exprtk-Swift.h"
#endif

@implementation NativeMidiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeMidiPlugin registerWithRegistrar:registrar];
}
@end
