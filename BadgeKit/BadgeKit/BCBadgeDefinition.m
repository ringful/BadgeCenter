//
//  BCBade.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadgeDefinition.h"


@implementation BCBadgeDefinition


- (id)initFromDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.name        = [dict objectForKey:@"id"];
        self.displayName = [dict objectForKey:@"name"];
        self.metricName  = [dict objectForKey:@"metric"];
        self.levels      = [dict objectForKey:@"levels"];
        self.messages    = [dict objectForKey:@"messages"];
    }
    return self;
}

// quick hack
-(int) levelForValue:(int) value {
    int level = 0;
    
    for (int i =0; i<[self.levels count]; i++) {
        NSNumber *number = [self.levels objectAtIndex:i];
        if (value >=[number intValue]) {
            level++;
        }        
    }
    return level;
}

- (BCBadge*) badgeLevel:(int) level {
    NSString* imageName = [NSString stringWithFormat:@"%@-%d", self.name, level];
    
    return [BCBadge badgeWithImage:imageName
                                  level:level
                                name:self.displayName
                                message:[self.messages objectAtIndex:level-1]];
}


@end
