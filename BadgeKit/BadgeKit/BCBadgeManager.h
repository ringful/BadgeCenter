//
//  BCBadgeManager.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCBadgeManager : NSObject

+ (BCBadgeManager*) sharedManager;
-(UIViewController*) badgeViewController;

- (NSString*) backgroundImageName;

- (NSArray*) metricDefinitions;
- (NSArray*) badgeDefinitions;
- (NSArray*) currentBadges;

- (NSInteger) incrementMetric:(NSString*) metricName by:(NSInteger) increment;
- (NSInteger) setMetric:(NSString*) metricName to:(NSInteger) value;

@end
