//
//  BCBade.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCBadgeLevel.h"
#import <BadgeKit/BadgeKit.h>

@interface BCBadge : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *metricName;
@property (nonatomic, strong) NSArray *levels;

- (id)initFromDictionary: (NSDictionary*) dict;

- (int) levelForValue:(int) value;
- (BCBadgeLevel*) badgeLevel:(int) value;
@end
