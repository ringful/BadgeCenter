//
//  BCBade.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadge.h"

@implementation BCBadge

- (id)initFromDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:@"id"];
        self.displayName = [dict objectForKey:@"name"];
        self.metricName = [dict objectForKey:@"metric"];        
        self.levels = [dict objectForKey:@"levels"];
    }
    return self;
}

// quick hack
-(int) levelForValue:(int) value {
    int level = 0;
    
    for (int i =0; i<[self.levels count]; i++) {
        NSNumber *number = [self.levels objectAtIndex:i];
        //NSLog(@"intValue %d", [number intValue]);
        if (value >[number intValue]) {
            level++;
        }        
    }


    return level;
}

- (BCBadgeLevel*) badgeLevel:(int) level {
    NSString* imageName = [NSString stringWithFormat:@"%@-%d", self.name, level];
    
    return [BCBadgeLevel badgeWithImage:imageName
                                andName:self.displayName];
}


@end
