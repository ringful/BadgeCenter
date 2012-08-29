//
//  BCBade.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCBadge.h"

@interface BCBadgeDefinition : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *metricName;
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic, strong) NSArray *messages;

- (id)initFromDictionary: (NSDictionary*) dict;

- (int) levelForValue:(int) value;
- (BCBadge*) badgeLevel:(int) value;
@end
