#import "FlutterExprtkIosPlugin.h"
#if __has_include(<flutter_exprtk_ios/flutter_exprtk_ios-Swift.h>)
#import <flutter_exprtk_ios/flutter_exprtk_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_exprtk_ios-Swift.h"
#endif

@implementation FlutterExprtkIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterExprtkIosPlugin registerWithRegistrar:registrar];
}
@end
