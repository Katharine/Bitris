//
//  BitrisEndlessGameController.m
//  Bitris
//
//  Created by Katharine Berry on 07/02/2010.
//  Copyright 2010 AjaxLife Developments. All rights reserved.
//

#import "BitrisEndlessGameController.h"


@implementation BitrisEndlessGameController

- (void)skipPiece {
    [self pause];
}

- (void)missedPiece {
    [self gameOver];
}

- (NSString *)leaderboardType {
    return LEADERBOARD_ENDLESS;
}

- (void)pickNextPiece {
    if([remainingPieces count] < 3) {
        [self fillRemainingPieces];
    }
    [super pickNextPiece];
}

@end
