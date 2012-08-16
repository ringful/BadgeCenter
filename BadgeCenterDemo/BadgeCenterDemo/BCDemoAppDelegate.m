//
//  BCDemoAppDelegate.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/16/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCDemoAppDelegate.h"
#import "BCDemoViewController.h"

#import <BadgeKit/BCBadgeManager.h>


@interface BCDemoAppDelegate ()
    @property (nonatomic, strong) BCBadgeManager* manager;
@end


@implementation BCDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.manager = [[BCBadgeManager alloc] init];
    NSLog(@"Manager! %@", _manager);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[BCDemoViewController alloc] initWithNibName:@"BCDemoViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
		
- (UIViewController*) badgeViewController {
    return [_manager badgeViewController];
}


- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
