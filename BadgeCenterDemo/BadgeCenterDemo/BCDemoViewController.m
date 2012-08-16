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

@property (strong, nonatomic) NSArray *metricNames;
@end

@implementation BCDemoViewController


static const int TITLE_BASE=301;
static const int COUNT_BASE = 201;
static const int STEP_BASE = 101;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.metricNames = [NSArray arrayWithObjects:@"reported",
                        @"user",
                        @"daysused",
                        @"appused",
                        @"safe",
                        @"scan",
                        @"social",
                        nil];
}

- (void)viewWillAppear:(BOOL)animated {
    BCBadgeManager* manager = [BCBadgeManager sharedManager];
    for (int i=0; i<[_metricNames count]; i++) {
        NSString* metricName = [_metricNames objectAtIndex:i];
        int current = [manager metric:metricName];
        
        [[self stepper:i] setValue:current];
        [[self count:i] setText:[self countAsString:current]];
        [[self title:i] setText:metricName];        
    }
}

-(UIStepper*) stepper:(int) i {
    return (UIStepper*) [self.view viewWithTag:STEP_BASE+i];
}

-(UILabel*) count:(int) i {
    return (UILabel*) [self.view viewWithTag:COUNT_BASE+i];
}

-(UILabel*) title:(int) i {
    return (UILabel*) [self.view viewWithTag:TITLE_BASE+i];
}

-(NSString*) countAsString:(int) count {
    return [NSString stringWithFormat:@"%d", count];
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
    
    [self presentModalViewController:badgeView animated:YES];
}


- (IBAction)bumpCounter:(UIStepper *)sender {
    int metricNumber = sender.tag - STEP_BASE;    
    int value = (int) sender.value;
    
    [[BCBadgeManager sharedManager] setMetric:[_metricNames objectAtIndex:metricNumber] to:value];

    // shouldn't update.  we should have a delegate on manager or event for metric change that
    // we wait for....
    UILabel* count = (UILabel*) [self.view viewWithTag:COUNT_BASE+metricNumber];
    count.text = [self countAsString: value];
}
@end
