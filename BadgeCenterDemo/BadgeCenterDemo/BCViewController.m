//
//  BCViewController.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCViewController.h"
#import "BCBadgeLevel.h"

int const kBadgesPerRow    = 3;
int const kBadgeViewWidth  = 100;
int const kBadgeViewHeight = 100;

@interface BCViewController ()
@property (nonatomic, strong) NSArray* badges;

@end

@implementation BCViewController
@synthesize backgroundView = _backgroundView;
@synthesize badgesView = _badgesView;
@synthesize header = _header;
@synthesize subtitle = _subtitle;

static const NSString* kBCOptionBackground = @"background";

- (void)viewDidLoad
{    
    [super viewDidLoad];
    [self loadPreferences];
    
    [self setBackground];
    
    self.header.text = @"Badge Collection";
    self.subtitle.text = @"You have earned X of Y badges";
    
    self.badges = [NSArray arrayWithObjects:
                   [BCBadgeLevel badgeWithImage:@"officialuser-3"
                                        andName:@"Official User"],
                   [BCBadgeLevel badgeWithImage:@"scanmaster-2"
                                        andName:@"Scan Master"],
                   [BCBadgeLevel badgeWithImage:@"reporter-1"
                                        andName:@"Reporter"],
                   [BCBadgeLevel badgeWithImage:@"officialuser-1"
                                        andName:@"Official User"],
                   [BCBadgeLevel badgeWithImage:@"playitsafe-1"
                                        andName:@"Play it Safe"],
                   [BCBadgeLevel badgeWithImage:@"socialite-3"
                                        andName:@"Socialite"],
                   [BCBadgeLevel badgeWithImage:@"applover-2"
                                        andName:@"App Lover"],

                   nil];
    
    
    [self renderBadgesInto:self.badgesView];
}

-(void) setBackground {
    NSString* imageName = [self.badgeOptions objectForKey:kBCOptionBackground];
    if (imageName) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            self.backgroundView.image = image;
        }
    }
}

-(void) loadPreferences {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BCBadgeDefinitions" ofType:@"plist"];
    if (path) {
        self.badgeOptions = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    }
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
    [self setBadgeOptions:nil];
    
    [self setBackgroundView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
