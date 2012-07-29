//
//  BCViewController.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView  *badgesView;
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@property (strong,nonatomic) NSDictionary *badgeOptions;


@end
