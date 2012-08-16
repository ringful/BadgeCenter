//
//  BCDemoViewController.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/16/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCDemoViewController.h"
#import <BadgeKit/BCBadgeManager.h>

@interface BCDemoViewController ()

@end

@implementation BCDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)viewMyBadges:(id)sender {    
    UIViewController* badgeView = [[BCBadgeManager sharedManager] badgeViewController];
    
    NSLog(@"nav=%@ badgeview=%@", self.navigationController, badgeView);
    [self presentModalViewController:badgeView animated:YES];
}
@end
