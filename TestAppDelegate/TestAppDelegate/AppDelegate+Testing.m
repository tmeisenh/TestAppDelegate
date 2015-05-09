#import "AppDelegate+Testing.h"

#import <objc/runtime.h>

/*
 
 A big drawback to how unit tests are executed with iOS is that the application is actually launched and it seems
 tests are run in parallel.  This is a particular problem if you are using events (NSNotifications) for observation
 purposes and you're wanting to test event posting or handling.  This is mostly only a problem if you're using NSNotifications
 and listening on nil which is often the case with CoreData and context saves...
 
 This category, when added to your test target, swaps out application:didFinishLaunchingWithOptions in your AppDelegate
 with an implementation that does nothing and prevents your app from launching within a test context.
 
 */

@implementation AppDelegate (Testing)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle:@selector(application:didFinishLaunchingWithOptions:)
                              with:@selector(testing_application:didFinishLaunchingWithOptions:)];
    });
}

+ (void)swizzle:(SEL)old with:(SEL)new {
    Method oldMethod, newMethod;
    
    oldMethod = class_getInstanceMethod(self, old);
    newMethod = class_getInstanceMethod(self, new);
    
    if (class_addMethod(self, old, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(self, new, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    }
    else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

- (BOOL)testing_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

@end
