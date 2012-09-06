//
//  BCViewController.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 7/27/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <Twitter/Twitter.h>

#import "BCViewController.h"
#import "BCBadge.h"
#import "BCBadgeManager.h"
#import "BCMetric.h"
#import "BCBadgeDefinition.h"


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
    
    self.title = @"My Badges";
    self.header.text   = @"Badge Collection";

    [self setBadgeCount];
    self.badges = [_badgeManager currentBadges];
    
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 460.0);
    
    [self renderBadgesInto:self.badgesView];
}

-(void) setBackground {
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[_badgeManager backgroundImageName]]];
    [self.view setBackgroundColor:bgColor];
}

-(int) earnedBadgeCount:(NSArray*)badgeLevels {
    int earned = 0;
    for (BCBadge* badgeLevel in badgeLevels) {
        if (badgeLevel.level > 1) {
            earned++;
        }
    }
    return earned;
}


-(void) setBadgeCount {
    NSArray* badgeLevels =[_badgeManager currentBadges];
    
    self.subtitle.text = [NSString stringWithFormat:@"You have earned %d of %d badges",
                          [self earnedBadgeCount: badgeLevels],
                          [badgeLevels count]];
}


- (void) renderBadgesInto:(UIView *) parentView {
    for (int pos = 0; pos < [self numberOfBadges]; pos++) {
        BCBadge* level = [self badgeForPosition:pos];
        
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

- (BCBadge*) badgeForPosition:(int) pos {
    return [self.badges objectAtIndex:pos];
}

- (CGRect) positionForBadgeNumber:(int) pos {
    int row = pos / kBadgesPerRow;
    int col = pos % kBadgesPerRow;
    
    // a few more hacks until we create a real view
    return CGRectMake(kBadgeViewWidth*col, kBadgeViewHeight*row, kBadgeViewWidth, kBadgeViewHeight);
}

- (UIImage*) imageForBadgeLevel:(BCBadge*) badgeLevel {
    return [UIImage imageNamed:badgeLevel.badgeImage];
}

- (void)viewDidUnload
{
    [self setBadgesView:nil];
    [self setTitle:nil];
    [self setSubtitle:nil];
    
    // [self setBackgroundView:nil];
    [super viewDidUnload];
}


- (void)badgeClicked:(UIButton*) sender {
    BCBadge* badge = [_badges objectAtIndex:[sender tag]];

    UIAlertView *alert = nil;
    
    if (badge.level > 1) {
        alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                message:[NSString stringWithFormat:@"You have earned %@", badge.message]
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:@"Tweet",nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Try again"
                        message:badge.message
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
    }
    
    alert.tag = [sender tag];
    
    [alert show];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    BCBadge* badge = [_badges objectAtIndex:[alertView tag]];

    if (buttonIndex == 0) {
        return;
    } else {
        [self tweetBadge:badge];
    }    
}

-(void)tweetBadge:(BCBadge*) badge {    
    TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
    
    [tweetSheet setInitialText:[NSString stringWithFormat:@"I just earned %@", badge.message]];
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
