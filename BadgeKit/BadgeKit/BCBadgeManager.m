//
//  BCBadgeManager.m
//  BadgeCenterDemo
//
//  Created by Norman Richards on 8/5/12.
//  Copyright (c) 2012 Ringful. All rights reserved.
//

#import "BCBadgeManager.h"
#import "BCMetric.h"
#import "BCBadge.h"
#import "BCViewController.m"


static const NSString* kBCOptionBackground = @"background";
static const NSString* kBCOptionMetrics    = @"metrics";
static const NSString* kBCBadges           = @"badges";


static NSString* kBCPListMetrics = @"BCMetrics.plist";
static NSString* kBCPListBadges  = @"BCBadges.plist";

@interface BCBadgeManager ()
  
@property (strong, nonatomic) NSDictionary *badgeOptions;
@property (strong, nonatomic) NSMutableDictionary *metrics;
@property (strong, nonatomic) NSMutableDictionary *userBadges;

@end


@implementation BCBadgeManager

static BCBadgeManager *sharedInstance = nil;

+ (BCBadgeManager*) sharedManager {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadBadgeDefinitions];
        NSLog(@"reading %@", [self metricsFileName]);        
        [self loadMetrics];
        NSLog(@"reading %@", [self userBadgesFileName]);
        [self loadBadges];
    }
    return self;
}

-(NSString*) metricsFileName {
    NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent: kBCPListMetrics];
}

-(NSString*) userBadgesFileName {
    NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent: kBCPListBadges];
}


# pragma mark read files

-(void) loadBadgeDefinitions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BCBadgeDefinitions" ofType:@"plist"];
    if (path) {
        self.badgeOptions = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
}


-(void) loadMetrics {    
    self.metrics = [[NSMutableDictionary alloc] initWithContentsOfFile:[self metricsFileName]];
    if (!_metrics) {
        self.metrics = [NSMutableDictionary dictionaryWithCapacity:50];
    }
    NSLog(@"loaded %d metrics", [_metrics count]);
}

-(void) loadBadges {    
    NSMutableDictionary* loadedBadges = [[NSMutableDictionary alloc] initWithContentsOfFile:[self userBadgesFileName]];
    if (!loadedBadges) {
        loadedBadges = [NSMutableDictionary dictionaryWithCapacity:50];
    }
    NSLog(@"loaded %d badges", [loadedBadges count]);
    self.userBadges = loadedBadges;
    if ([self updateBadges]) {
        [self saveBadges];
    }
}

// update badges from new definitions
- (BOOL) updateBadges {
    BOOL dirty = false;
    for (BCBadge* badge in [self badgeDefinitions]) {
        if ([_userBadges objectForKey:badge.name] == nil) {
            [_userBadges setObject:[NSNumber numberWithInt:1] forKey:badge.name];
            dirty = true;
        }
    }
    return dirty;
}

#pragma mark write files
-(void) saveBadges {
    NSLog(@"writing %d badges", [_userBadges count]);
    [_userBadges writeToFile:[self userBadgesFileName] atomically:YES];    
}

-(void) saveMetrics {
    NSLog(@"writing %d metrics", [_metrics count]);
    [_metrics writeToFile:[self metricsFileName] atomically:YES];
}


#pragma mark user stuff

- (NSString*) backgroundImageName {
    return [_badgeOptions objectForKey:kBCOptionBackground];
}

- (NSArray*) metricDefinitions {
    NSMutableArray* metrics = [NSMutableArray array];
    
    for (NSString* metricName in [_badgeOptions objectForKey:kBCOptionMetrics]) {
        [metrics addObject:[[BCMetric alloc] initWithName:metricName]];
    }
    
    return metrics;
}

- (NSArray*) badgeDefinitions {
    NSMutableArray* defs = [NSMutableArray array];
    
    for (NSDictionary* badgeDict in [_badgeOptions objectForKey:kBCBadges]) {
        [defs addObject:[[BCBadge alloc] initFromDictionary:badgeDict]];
    }
    return defs;
}

// ugly
-(BCBadge*) badgeNamed:(NSString*) name in:(NSArray*) defs {
    for (BCBadge* badge in defs) {
        if ([name isEqualToString:badge.name]) {
            return badge;
        }
    }
    return nil;    
}

-(NSArray*) currentBadges {
    NSArray *defs = [self badgeDefinitions];
    
    NSMutableArray *badges = [NSMutableArray array];
    for (NSString* badgeName in [_userBadges keyEnumerator]) {
        NSNumber* number = [_userBadges objectForKey:badgeName];
        BCBadge* badge = [self badgeNamed:badgeName in:defs];
        if (badge) {
            [badges addObject:[badge badgeLevel:[number intValue]]];
        }
    }
    return badges;
}

-(void) checkBadges {
    NSArray *defs = [self badgeDefinitions];
    
    for (BCBadge* badge in defs) {
        int levelForCurrentMetric = [badge levelForValue:[self metric:badge.metricName]];
        int currentLevel = [self badgeLevel:badge.name];
        
        NSLog(@"badge %@ metric %@ at %d want %d", badge.name, badge.metricName, currentLevel, levelForCurrentMetric);
        
        if (levelForCurrentMetric > [self badgeLevel:badge.name]) {
            [_userBadges setObject:[NSNumber numberWithInt:levelForCurrentMetric] forKey:badge.name];
            [self saveBadges];
            
            [self badgeDidLevelUp:badge.name];
        }        
    }
}

-(NSInteger) badgeLevel: (NSString*) badgeName {
    NSNumber* current = [_userBadges objectForKey:badgeName];
    return [current integerValue];
}

-(NSInteger) metric:(NSString*) metricName {
    NSNumber* current = [_metrics objectForKey:metricName];    
    return [current integerValue];
}

-(NSInteger) incrementMetric:(NSString*) metricName by:(NSInteger) increment{
    int newValue =  increment + [self metric:metricName];
    return [self setMetric:metricName to:newValue];
}

-(NSInteger) setMetric:(NSString*) metricName to:(NSInteger)value {
    [_metrics setValue:[NSNumber numberWithInt:value] forKey:metricName];
    [self metricDidChange:metricName to:value];
    return value;
}


-(void) metricDidChange:(NSString*) name to:(int) value {
    NSLog(@"metric %@ is now %d", name, value);
    [self saveMetrics];
    [self checkBadges];
}

-(void) badgeDidLevelUp: (NSString*) name {
    // call a delegate perhaps
    NSLog(@"baged %@ level up", name);
}


#pragma mark UI

-(UIViewController*) badgeViewController {
    BCViewController* controller = [[BCViewController alloc] initWithNibName:@"BCBadgeView" bundle:nil];
    NSLog(@"got view controller %@", controller);
    return controller;
}

@end
