//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BitrisBoardView.h"
#import "BitrisPieceView.h"
#import "KBCircularProgressView.h"
#import "AGON.h"

typedef enum {
    BitrisGameClassic,
    BitrisGameEndless
} BitrisGameType;

#define TIME_LIMIT 10.0
#define SCORE_2x2 5
#define SCORE_2x3 15
#define SCORE_3x3 30

#define AWARD_MADE_2x2 0
#define AWARD_MADE_2x3 1
#define AWARD_MADE_3x3 2

#define AWARD_CLASSIC_100 3
#define AWARD_CLASSIC_200 4
#define AWARD_CLASSIC_300 5

#define SCOREBOARD_CLASSIC 0
#define SCOREBOARD_ENDLESS 1

@interface BitrisGameController : UIViewController <BitrisBoardDelegate, UIAlertViewDelegate> {
    IBOutlet BitrisBoardView *gameBoard;
    IBOutlet BitrisPieceView *thisPieceView;
    IBOutlet BitrisPieceView *nextPieceView;
    IBOutlet BitrisPieceView *nextNextPieceView;
    IBOutlet UILabel *scoreView;
    IBOutlet KBCircularProgressView *timerView;
    NSMutableArray *remainingPieces;
    NSArray *allPieces;
    BitrisPiece *currentPiece;
    NSInteger currentScore;
    NSTimer *pieceTimer;
    NSDate *timerEndTime;
    BitrisGameType gameType;
    float pauseTimeRemaining;
}

- (ushort)guessIntendedCellForPiece:(BitrisPiece *)piece atCell:(ushort)cell;
- (NSArray *)loadBitrisPieces;
- (void)startTimer;
- (void)stopTimer;
- (void)timerFired;
- (void)missedPiece;
- (void)updateScore:(NSInteger)delta;
- (void)pickNextPiece;
- (void)showMenu;
- (void)gameOver;
- (void)fillRemainingPieces;
- (void)pause;
- (void)unpause;
- (void)unlockAward:(NSInteger)awardID;
- (void)hideAwardNotification:(UIView *)awardView;
- (void)awardNotificationGone:(NSString *)animationID finished:(NSNumber *)finished context:(UIView *)awardView;

@property(retain) IBOutlet BitrisBoardView *gameBoard;
@property(retain) IBOutlet BitrisPieceView *thisPieceView;
@property(retain) IBOutlet BitrisPieceView *nextPieceView;
@property(retain) IBOutlet BitrisPieceView *nextNextPieceView;
@property(retain) IBOutlet UILabel *scoreView;
@property(retain) IBOutlet KBCircularProgressView *timerView;
@property BitrisGameType gameType;
@end
