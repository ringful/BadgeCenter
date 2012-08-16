//
//  BCDemoAppDelegate.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/16/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCDemoViewController.h"

@interface BCDemoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BCDemoViewController* viewController;

- (UIViewController*) badgeViewController;

@end
