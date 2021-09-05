#import "FlutterExprtkNativePlugin.h"
#if __has_include(<flutter_exprtk_native/flutter_exprtk_native-Swift.h>)
#import <flutter_exprtk_native/flutter_exprtk_native-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_exprtk_native-Swift.h"
#endif

@implementation FlutterExprtkNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterExprtkNativePlugin registerWithRegistrar:registrar];
}
@end
