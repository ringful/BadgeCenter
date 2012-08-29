//
//  BCBadgeLevel.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadge.h"

@implementation BCBadge

+(BCBadge*) badgeWithImage:(NSString*) image
                          level:(int) level
                           name:(NSString*) name
                        message:(NSString*)message
{
    BCBadge* badge = [[BCBadge alloc] init];
    badge.badgeImage = image;
    badge.badgeName = name;
    badge.message = message;
    badge.level = level;
    
    return badge;
}

@end

