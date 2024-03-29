//
//  BCDemoViewController.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/16/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCDemoViewController.h"
#import <BadgeKit/BCBadgeManager.h>
#import <BadgeKit/BCBadge.h>


@interface BCDemoViewController ()
@property (strong, nonatomic) NSArray *metricNames;
@property (strong, nonatomic) UIPopoverController *badgePopover;
@end

@implementation BCDemoViewController

static const int STEP_BASE  = 101;
static const int COUNT_BASE = 201;
static const int TITLE_BASE = 301;

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
    self.navigationItem.title = @"BadgeKit Demo";

    BCBadgeManager* manager = [BCBadgeManager sharedManager];
    for (int i=0; i<[_metricNames count]; i++) {
        NSString* metricName = [_metricNames objectAtIndex:i];
        int current = [manager metric:metricName];
        
        [[self stepper:i] setValue:current];
        [[self count:i] setText:[self countAsString:current]];
        [[self title:i] setText:metricName];        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(levelUp:)
                                                 name:kBCNotificationLevelUp
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(metricChanged:)
                                                 name:kBCNotificationMetricChanged
                                               object:nil];

}

-(void) viewWillDisappear:(BOOL)animated {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationItem.title=@"Demo";
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (self.badgePopover) {
        [self.badgePopover dismissPopoverAnimated:NO];
        self.badgePopover = nil;
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
    
    if (self.navigationController) {
        [self.navigationController pushViewController:badgeView animated:YES];
    } else {
        [self presentModalViewController:badgeView animated:YES];
    }
}


- (IBAction)viewMyBadgesInPopover:(id)sender {
    UIViewController* badgeView = [[BCBadgeManager sharedManager] badgeViewController];
    
    self.badgePopover = [[UIPopoverController alloc] initWithContentViewController:badgeView];
    self.badgePopover.delegate = self;
    
    [self.badgePopover presentPopoverFromRect: [sender frame]
                             inView: self.view
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
    
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (popoverController == self.badgePopover) {
        self.badgePopover = nil;
    }
}


- (IBAction)bumpCounter:(UIStepper *)sender {
    int metricNumber = sender.tag - STEP_BASE;    
    int value = (int) sender.value;
    
    [[BCBadgeManager sharedManager] setMetric:[_metricNames objectAtIndex:metricNumber] to:value];
}

-(void) metricChanged:(NSNotification*) notification {
    NSDictionary* info = [notification userInfo];
    NSLog(@"Metric changed %@", info);
    
    NSString* metricName = [info objectForKey:@"metric"];
    NSNumber* value      = [info objectForKey:@"value"];
    
    int metricNumber = [_metricNames indexOfObject:metricName];
    if (metricNumber != NSNotFound) {
        [[self stepper:metricNumber] setValue:[value intValue]];
        [[self count:metricNumber] setText:[self countAsString:[value intValue]]];        
    }    
}


-(void) levelUp:(NSNotification*) notification{
    NSDictionary* info = [notification userInfo];    
    NSLog(@"LEVEL UP! %@", info);
    
    BCBadge* badge = [info objectForKey:@"badge"];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Level Up %@", badge.badgeName]
                                                        message:[NSString stringWithFormat:@"You have just earned %@", badge.message]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

@end
