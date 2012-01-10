//
//  KBGKScoreSubmitter.m
//  Bitris
//
//  Created by Katharine Berry on 08/01/2012.
//  Copyright 2012 AjaxLife Developments. All rights reserved.
//

#import "KBGameCenter.h"

@implementation KBGameCenter

- (id)init {
    self = [super init];
    if (self) {
        // Load the achievements (Game Center is canonical, but we want to always have *something*)
        achievements = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"gkachieve"]] retain];
        if(!achievements) {
            NSLog(@"Restoring achievement dictionary failed.");
            achievements = [[NSMutableDictionary alloc] init];
        }
        
        // Load the achievement submission queue
        achievementQueue = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"gkachieveq"]] retain];
        if(!achievementQueue) {
            NSLog(@"Restoring achievement queue failed.");
            achievementQueue = [[NSMutableArray alloc] init];
        }
        
        // Load with the score queue
        scoreQueue = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath:@"gkscores"]] retain];
        if(!scoreQueue) {
            NSLog(@"Restoring score queue failed.");
            scoreQueue = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (void)updateAchievements {
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievementsFound, NSError *error) {
        for(GKAchievement *achievement in achievementsFound) {
            [achievements setObject:achievement forKey:achievement.identifier];
        }
    }];
}

+ (KBGameCenter *)shared {
    static KBGameCenter *thing;
    if(thing == nil) {
        thing = [[self alloc] init];
    }
    return thing;
}

- (GKAchievement *)fetchAchievement:(NSString *)achievement {
    return [achievements objectForKey:achievement];
}

- (BOOL)hasAchievement:(NSString *)achivementID {
    GKAchievement *achievement = [self fetchAchievement:achivementID];
    if(achievement) {
        return (achievement.percentComplete == 100.0);
    } else {
        return NO;
    }
}

- (void)unlockAchievement:(NSString *)achievementID {
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier:achievementID] autorelease];
    achievement.showsCompletionBanner = YES;
    achievement.percentComplete = 100.0;
    [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Error unlocking achievement %@: %@", achievementID, [error description]);
            [achievementQueue addObject:achievement];
        }
    }];
    [achievements setObject:achievement forKey:achievementID];
}

- (void)submitScore:(GKScore *)score {
    [score reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil) {
            NSLog(@"Error reporting score: %@", [error description]);
            [scoreQueue addObject:score];
        } else {
            NSLog(@"Successfully reported score of %lld (%@)", score.value, score);
        }
    }];
}

- (void)submitQueue {
    NSMutableArray *objectsToRemove = [[[NSMutableArray alloc] init] autorelease];
    for(GKScore *score in scoreQueue) {
        [score reportScoreWithCompletionHandler:^(NSError *error) {
            if(error == nil) {
                [objectsToRemove addObject:score];
                NSLog(@"Submitted queued score.");
            } else {
                NSLog(@"Failed to submit queued score: %@", error);
            }
        }];
    }
    [scoreQueue removeObjectsInArray:objectsToRemove];
    [objectsToRemove removeAllObjects];
    
    for(GKAchievement *achievement in achievementQueue) {
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
            if(!error) {
                [objectsToRemove addObject:achievement];
                NSLog(@"Submitted queued achievement.");
            } else {
                NSLog(@"Failed to submit queued achievement.");
            }
        }];
    }
    [achievementQueue removeObjectsInArray:objectsToRemove];
}

- (NSString *)filePath:(NSString *)file {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:file];
    return path;
}

- (void)storeCache {
    if(![NSKeyedArchiver archiveRootObject:scoreQueue toFile:[self filePath:@"gkscores"]]) {
        NSLog(@"FAIL: Lost high score queue! Archiving failed. Listing any contents:");
        for(GKScore *score in scoreQueue) {
            NSLog(@"%@ (%@): %lld points", [score playerID], [score date], [score value]);
        }
    }
    
    if(![NSKeyedArchiver archiveRootObject:achievementQueue toFile:[self filePath:@"gkachieveq"]]) {
        NSLog(@"FAIL: Lost achievement queue! Archiving failed.");
    }
    
    if(![NSKeyedArchiver archiveRootObject:achievements toFile:[self filePath:@"gkachieve"]]) {
        NSLog(@"Archiving achievement cache failed.");
    }
}

- (void)dealloc {
    [scoreQueue release];
    [super dealloc];
}

@end
