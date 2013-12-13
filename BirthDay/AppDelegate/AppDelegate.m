//  Created by Phuoc on 11/5/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactViewController.h"
#import "GyflViewController.h"
#import "ShopCardViewController.h"
#import "EventViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSMutableArray *sampleArray = [NSMutableArray array];
    NSString *firstObj = [sampleArray objectAtIndex:1];
    NSLog(@"%@",firstObj);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ContactViewController *contactVC   = [[ContactViewController alloc] init];
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactVC];
    
    GyflViewController *gyftVC      = [[GyflViewController alloc] init];
    UINavigationController *gyftNav = [[UINavigationController alloc] initWithRootViewController:gyftVC];
    gyftNav.navigationBarHidden     = NO;
    
    
    EventViewController *eventVC        = [[EventViewController alloc] init];
    UINavigationController *eventNav    = [[UINavigationController alloc] initWithRootViewController:eventVC];
    
    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = [NSArray arrayWithObjects:contactNav, gyftNav, eventNav, nil];
    
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Contacts"];
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Gyft"];
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Events"];
    
    self.window.rootViewController  = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - Public Methods

- (void) showAlertView:(NSString *)title withMessage:(NSString *)message inView:(UIView *)view
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    
    [alert show];
}


#pragma mark - System Methods

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
