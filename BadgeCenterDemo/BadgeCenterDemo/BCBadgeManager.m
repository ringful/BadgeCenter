//
//  BCBadgeManager.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadgeManager.h"
#import "BCMetric.h"
#import "BCBadge.h"


static const NSString* kBCOptionBackground = @"background";
static const NSString* kBCOptionMetrics    = @"metrics";
static const NSString* kBCBadges           = @"badges";

@interface BCBadgeManager ()
  
@property (strong,nonatomic) NSDictionary *badgeOptions;

@end


@implementation BCBadgeManager

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BCBadgeDefinitions" ofType:@"plist"];
        if (path) {
            self.badgeOptions = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        }
    }
    return self;
}


- (NSString*) backgroundImageName {
    return [_badgeOptions objectForKey:kBCOptionBackground];
}

- (NSArray*) metrics {
    NSMutableArray* metrics = [NSMutableArray array];
    
    for (NSString* metricName in [_badgeOptions objectForKey:kBCOptionMetrics]) {
        [metrics addObject:[[BCMetric alloc] initWithName:metricName]];
    }
    
    return metrics;
}

- (NSArray*) badgeDefinitions {
    NSMutableArray* defs = [NSMutableArray array];
    
    for (NSDictionary* badgeDict in [_badgeOptions objectForKey:kBCBadges]) {
        [defs addObject:[[BCBadge alloc] initFromDictionary:badgeDict]];
    }
    return defs;
}



@end
