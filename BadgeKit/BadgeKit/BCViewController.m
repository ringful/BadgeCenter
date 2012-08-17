//
//  BCViewController.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <Twitter/Twitter.h>

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
    self.badgeManager = [BCBadgeManager sharedManager];
    
    [self setBackground];

    self.header.text   = @"Badge Collection";
    [self setBadgeCount];
    
    self.badges = [self createBadgeList];

    NSLog(@"testing metric is now %d", [_badgeManager incrementMetric:@"testing" by:1]);

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

-(void) setBadgeCount {
    NSArray* badgeLevels =[_badgeManager currentBadges];
    
    int earned = 0;
    for (BCBadgeLevel* badgeLevel in badgeLevels) {
        if (badgeLevel.level > 1) {
            earned++;
        }
    }
    

    
    self.subtitle.text = [NSString stringWithFormat:@"You have earned %d of %d badges",
                          earned,
                          [badgeLevels count]];

}

-(NSArray*) createBadgeList {
    return [_badgeManager currentBadges];
}

- (void) renderBadgesInto:(UIView *) parentView {
    for (int pos = 0; pos < [self numberOfBadges]; pos++) {
        BCBadgeLevel* level = [self badgeForPosition:pos];
        
        UIView* badgeView = [[UIView alloc] initWithFrame:[self positionForBadgeNumber:pos]];
        
        UIImage* image = [self imageForBadgeLevel:level];
        UIButton* imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(10, 0, 80, 80);
        imageButton.tag = pos;        
        [imageButton setImage:image forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(badgeClicked:)
           forControlEvents:UIControlEventTouchUpInside];

        //UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        //imageView.frame = CGRectMake(10, 0, 80, 80);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,80,100,20)];
        label.text = level.badgeName;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        
        //[badgeView addSubview:imageView];
        [badgeView addSubview:imageButton];
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

- (void)badgeClicked:(UIButton*) sender {
    BCBadgeLevel* badge = [_badges objectAtIndex:[sender tag]];
    
    TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];

    [tweetSheet setInitialText:[NSString stringWithFormat:@"I just earned the %@ badge in BadgeCenterDemo!", badge.badgeName]];
    [tweetSheet addImage:[UIImage imageNamed:badge.badgeImage]];
    
    tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
        [self dismissModalViewControllerAnimated:YES];
    };
    
    [self presentModalViewController:tweetSheet animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)dismissBadgeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
