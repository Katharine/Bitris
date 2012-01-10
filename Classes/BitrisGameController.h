//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BitrisBoardDelegate.h"
@class KBCircularProgressView, BitrisPiece, BitrisPieceView, BitrisBoardView;

#define TIME_LIMIT 10.0
#define SCORE_2x2 5
#define SCORE_2x3 15
#define SCORE_3x3 30

#define AWARD_MADE_2x2 @"bitris.type.2x2"
#define AWARD_MADE_2x3 @"bitris.type.2x3"
#define AWARD_MADE_3x3 @"bitris.type.3x3"
#define AWARD_MADE_HACKER @"bitris.shape.hacker"

#define AWARD_CLASSIC_100 @"bitris.score.100"
#define AWARD_CLASSIC_200 @"bitris.score.200"
#define AWARD_CLASSIC_300 @"bitris.score.300"

#define LEADERBOARD_CLASSIC @"bitris.classic"
#define LEADERBOARD_ENDLESS @"bitris.endless"

@interface BitrisGameController : UIViewController <BitrisBoardDelegate, UIAlertViewDelegate, GKLeaderboardViewControllerDelegate> {
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
- (void)unlockAward:(NSString *)awardID;
- (void)skipPiece;
- (void)submitScore;
- (void)resetGame;
- (void)prepare;
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
