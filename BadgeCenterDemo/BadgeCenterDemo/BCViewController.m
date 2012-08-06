//
//  BCViewController.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCViewController.h"
#import "BCBadgeLevel.h"
#import "BCBadgeManager.h"
#import "BCMetric.h"
#import "BCBadge.h"


int const kBadgesPerRow    = 3;
int const kBadgeViewWidth  = 100;
int const kBadgeViewHeight = 100;

@interface BCViewController ()

@property (nonatomic, strong) NSArray* badges;
@property (nonatomic, strong) BCBadgeManager* badgeManager;

@end

@implementation BCViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    self.badgeManager = [[BCBadgeManager alloc] init];
    
    [self setBackground];

    for (BCMetric* metric in [_badgeManager metrics]) {
        NSLog(@"METRIC %@", metric.name);
    }
    
    for (BCBadge* badge in [_badgeManager badgeDefinitions]) {
        NSLog(@"BADGE %@", badge.name);
    }
    
    self.header.text = @"Badge Collection";
    self.subtitle.text = @"You have earned X of Y badges";
    
    
    
    self.badges = [self createBadgeList];
    
    [self renderBadgesInto:self.badgesView];
}

-(void) setBackground {
    NSString * imageName = [_badgeManager backgroundImageName];
    if (imageName) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            self.backgroundView.image = image;
        }
    }
}

-(NSArray*) createBadgeList {
    NSMutableArray *badges = [NSMutableArray array];
    
    
    for (BCBadge* badge in [_badgeManager badgeDefinitions]) {
        [badges addObject:[badge badgeLevelForValue:arc4random()%50]];
    }

    return badges;
}

- (void) renderBadgesInto:(UIView *) parentView {
    for (int pos = 0; pos < [self numberOfBadges]; pos++) {
        BCBadgeLevel* level = [self badgeForPosition:pos];
        
        UIView* badgeView = [[UIView alloc] initWithFrame:[self positionForBadgeNumber:pos]];
        
        UIImage* image = [self imageForBadgeLevel:level];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(10, 0, 80, 80);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,80,100,20)];
        label.text = level.badgeName;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        
        [badgeView addSubview:imageView];
        [badgeView addSubview:label];
        
        [parentView addSubview:badgeView];
    }
}
                   

- (int) numberOfBadges {
    return [self.badges count];
}

- (BCBadgeLevel*) badgeForPosition:(int) pos {
    return [self.badges objectAtIndex:pos];
}

- (CGRect) positionForBadgeNumber:(int) pos {
    int row = pos / kBadgesPerRow;
    int col = pos % kBadgesPerRow;
    
    // a few more hacks until we create a real view
    return CGRectMake(kBadgeViewWidth*col, kBadgeViewHeight*row, kBadgeViewWidth, kBadgeViewHeight);
}

- (UIImage*) imageForBadgeLevel:(BCBadgeLevel*) badgeLevel {
    return [UIImage imageNamed:badgeLevel.badgeImage];
}

- (void)viewDidUnload
{
    [self setBadgesView:nil];
    [self setTitle:nil];
    [self setSubtitle:nil];
    
    [self setBackgroundView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
