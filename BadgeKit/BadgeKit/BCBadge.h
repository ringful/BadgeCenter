//
//  BCBadgeLevel.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBadge : NSObject

+(BCBadge*) badgeWithImage:(NSString*) image
                          level:(int) level
                           name:(NSString*) name
                        message:(NSString*) message;

@property (nonatomic, copy) NSString *badgeImage;
@property (nonatomic, copy) NSString *badgeName;
@property (nonatomic, copy) NSString *message;
@property (nonatomic) int level;


@end
