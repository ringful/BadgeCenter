//
//  BCDemoViewController.h
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/16/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCDemoViewController : UIViewController <UIPopoverControllerDelegate>
- (IBAction)viewMyBadges:(id)sender;
- (IBAction)viewMyBadgesInPopover:(id)sender;
- (IBAction)bumpCounter:(UIStepper *)sender;
@end
