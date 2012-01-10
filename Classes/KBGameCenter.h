//
//  KBGKScoreSubmitter.h
//  Bitris
//
//  Created by Katharine Berry on 08/01/2012.
//  Copyright 2012 AjaxLife Developments. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface KBGameCenter : NSObject {
    NSMutableArray *scoreQueue;
    NSMutableDictionary *achievements;
    NSMutableArray *achievementQueue;
}

+ (KBGameCenter *)shared;

- (void)submitScore:(GKScore *)score;
- (void)submitQueue;
- (void)storeCache;

- (void)updateAchievements;
- (void)unlockAchievement:(NSString *)identifier;
- (BOOL)hasAchievement:(NSString *)identifier;
- (GKAchievement *)fetchAchievement:(NSString *)identifier;

- (NSString *)filePath:(NSString *)filename;

@end
