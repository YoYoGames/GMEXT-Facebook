#import "GMFacebook_ios.h"

// GMFacebook-Swift.h is deliberately not imported here. Its C++ interop half
// emits `namespace GMFacebook`, named after the Swift module, which collides
// with the GMFacebook ObjC class this file implements - clang reports it as
// "redefinition of 'GMFacebook' as a different kind of symbol". The generated
// GMFacebookInternal_ios.mm gets away with importing it because it never sees
// the ObjC interface. Declaring the three class methods is enough to forward
// to them; the linker resolves them against the real Swift class.
@interface GMFacebookLifecycle : NSObject
+ (void)onLaunch:(NSDictionary *)launchOptions;
+ (void)onResume;
+ (void)onOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation;
@end

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
