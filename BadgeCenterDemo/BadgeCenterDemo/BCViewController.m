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

- (void)viewDidLoad
{    
    [super viewDidLoad];

    NSLog(@"view is %@", self.view);
    
    self.badges = [NSArray arrayWithObjects:[BCBadgeLevel badgeWithImage:@"officialuser-3"],
                   [BCBadgeLevel badgeWithImage:@"scanmaster-2"],
                   [BCBadgeLevel badgeWithImage:@"reporter-1"],
                   [BCBadgeLevel badgeWithImage:@"officialuser-1"],
                   [BCBadgeLevel badgeWithImage:@"playitsafe-1"],
                   [BCBadgeLevel badgeWithImage:@"socialite-3"],
                   [BCBadgeLevel badgeWithImage:@"applover-2"],

                   nil];
    
    [self renderBadges];

}

- (void) renderBadges {
    for (int pos = 0; pos < [self numberOfBadges]; pos++) {
        BCBadgeLevel* level = [self badgeForPosition:pos];
                
        UIImage* image = [self imageForBadgeLevel:level];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = [self positionForBadgeNumber:pos];
        
        [self.view addSubview:imageView];        
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
    return CGRectMake(kBadgeViewWidth*col+10, kBadgeViewHeight*row, kBadgeViewWidth-20, kBadgeViewHeight-20);
}

- (UIImage*) imageForBadgeLevel:(BCBadgeLevel*) badgeLevel {
    return [UIImage imageNamed:badgeLevel.badgeImage];
}

- (void)viewDidUnload
{
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
