#import "GMFacebook_ios.h"
#import "GMFacebook-Swift.h"

@implementation GMFacebook

// Runner lifecycle hooks. iPad_RunnerAppDelegate sends these to the extension
// object it created, so they have to live on this class; GMFacebookLifecycle
// does the FBSDK work because the Swift implementation object is private to the
// generated bridge.

- (void)onLaunch:(NSDictionary *)launchOptions
{
    [GMFacebookLifecycle onLaunch:launchOptions];
}

- (void)onResume
{
    [GMFacebookLifecycle onResume];
}

- (void)onOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
{
    [GMFacebookLifecycle onOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation];
}

@end
