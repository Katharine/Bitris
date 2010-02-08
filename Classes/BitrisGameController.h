//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AGON.h"
#import "BitrisBoardDelegate.h"
@class KBCircularProgressView, BitrisPiece, BitrisPieceView, BitrisBoardView;

#define TIME_LIMIT 10.0
#define SCORE_2x2 5
#define SCORE_2x3 15
#define SCORE_3x3 30

#define AWARD_MADE_2x2 0
#define AWARD_MADE_2x3 1
#define AWARD_MADE_3x3 2
#define AWARD_MADE_HACKER 6

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
    IBOutlet UILabel *finalScoreView;
    IBOutlet UIView *gameOverView;
    NSMutableArray *remainingPieces;
    NSArray *allPieces;
    BitrisPiece *currentPiece;
    NSInteger currentScore;
    NSTimer *pieceTimer;
    NSDate *timerEndTime;
    float pauseTimeRemaining;
    BOOL isPaused;
    NSNumberFormatter *numberFormatter;
}

- (NSArray *)loadBitrisPieces;
- (void)startTimer;
- (void)stopTimer;
- (void)timerFired;
- (void)missedPiece;
- (void)updateScore:(NSInteger)delta;
- (void)pickNextPiece;
- (void)gameOver;
- (void)fillRemainingPieces;
- (void)pause;
- (void)unpause;
- (void)unlockAward:(NSInteger)awardID;
- (void)hideAwardNotification:(UIView *)awardView;
- (void)awardNotificationGone:(NSString *)animationID finished:(NSNumber *)finished context:(UIView *)awardView;
- (void)skipPiece;
- (void)submitScore;
- (IBAction)showMenu;
- (IBAction)showHighScores;
- (IBAction)retry;

@property(retain) IBOutlet BitrisBoardView *gameBoard;
@property(retain) IBOutlet BitrisPieceView *thisPieceView;
@property(retain) IBOutlet BitrisPieceView *nextPieceView;
@property(retain) IBOutlet BitrisPieceView *nextNextPieceView;
@property(retain) IBOutlet UILabel *scoreView;
@property(retain) IBOutlet KBCircularProgressView *timerView;

@property(retain) IBOutlet UIView *gameOverView;
@property(retain) IBOutlet UILabel *finalScoreView;

@end
