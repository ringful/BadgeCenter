//
//  BCBadgeLevel.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadgeLevel.h"

@implementation BCBadgeLevel

+(BCBadgeLevel*) badgeWithImage:(NSString*) image andName:(NSString*) name{
    BCBadgeLevel* badge = [[BCBadgeLevel alloc] init];
    badge.badgeImage = image;
    badge.badgeName = name;
    
    return badge;
}

@end
