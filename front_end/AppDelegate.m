#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ExampleViewController.h"
#import "RAAS.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [RAAS inviteManagerWithIdentifier:@1];
    [[RAAS inviteManager] associateToUserWithID:@1 andToken:@"henri"];
    [[RAAS inviteManager] checkDownloadEvent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self pushMainScreen];
    
    return YES;
}


- (void) pushMainScreen{
    ExampleViewController *controller = [[ExampleViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
}

@end
