//
//  BCBadgeLevel.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadgeLevel.h"

@implementation BCBadgeLevel

+(BCBadgeLevel*) badgeWithImage:(NSString*) image {
    BCBadgeLevel* badge = [[BCBadgeLevel alloc] init];
    badge.badgeImage = image;
    
    return badge;
}


@end

