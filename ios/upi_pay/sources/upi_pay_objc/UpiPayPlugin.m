#import "UpiPayPlugin.h"
#if __has_include(<upi_pay/upi_pay-Swift.h>)
#import <upi_pay/upi_pay-Swift.h>
#else
#import "upi_pay-Swift.h"
#endif

@implementation UpiPayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUpiPayPlugin registerWithRegistrar:registrar];
}
@end
