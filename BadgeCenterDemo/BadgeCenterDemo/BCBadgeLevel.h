//
//  BCBadgeLevel.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBadgeLevel : NSObject

+(BCBadgeLevel*) badgeWithImage:(NSString*) image andName:(NSString*) name;


@property (nonatomic, copy) NSString *badgeImage;
@property (nonatomic, copy) NSString *badgeName;


@end
