//
//  BitrisGameController.m
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisGameController.h"
#import "MainMenuController.h"
#import "BitrisBoardView.h"
#import "BitrisPieceView.h"
#import "KBCircularProgressView.h"
#import "BitrisPiece.h"
#import "KBGameCenter.h"


@implementation BitrisGameController
@synthesize gameBoard, thisPieceView, nextPieceView, nextNextPieceView, scoreView, timerView;
@synthesize finalScoreView, gameOverView;

#pragma mark Stuff

- (NSArray *)loadBitrisPieces {
    return [NSArray arrayWithObjects:
            BitrisPieceMake(0x0001, 0),
            BitrisPieceMake(0x0006, 1),
            BitrisPieceMake(0x000E, 2),
            BitrisPieceMake(0x008E, 2),
            BitrisPieceMake(0x0042, 1),
            BitrisPieceMake(0x0044, 2),
            BitrisPieceMake(0x0046, 1),
            BitrisPieceMake(0x004E, 2),
            BitrisPieceMake(0x0082, 1),
            BitrisPieceMake(0x0086, 2),
            BitrisPieceMake(0x00C2, 6),
            BitrisPieceMake(0x00C4, 7),
            BitrisPieceMake(0x00CC, 7),
            BitrisPieceMake(0x010E, 2),
            BitrisPieceMake(0x014E, 2),
            BitrisPieceMake(0x0186, 7),
            BitrisPieceMake(0x01C2, 7),
            BitrisPieceMake(0x01C4, 7),
            BitrisPieceMake(0x01C8, 7),
            BitrisPieceMake(0x01CA, 7),
            BitrisPieceMake(0x0842, 6),
            BitrisPieceMake(0x0846, 6),
            BitrisPieceMake(0x0888, 7),
            BitrisPieceMake(0x08C2, 6),
            BitrisPieceMake(0x08C4, 6),
            BitrisPieceMake(0x1086, 7),
            BitrisPieceMake(0x10C2, 7),
            BitrisPieceMake(0x10C4, 7),
            BitrisPieceMake(0x11C4, 7),
            BitrisPieceMake(0x1842, 6),
            BitrisPieceMake(0x1846, 6),
            BitrisPieceMake(0x1884, 7),
            BitrisPieceMake(0x1886, 7),
            BitrisPieceMake(0x2082, 7),
            BitrisPieceMake(0x288A, 7),
            nil];
}

- (void)startTimer {
    if (pieceTimer == nil) {
        pieceTimer = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                      target:self
                                                    selector:@selector(timerFired)
                                                    userInfo:nil
                                                     repeats:YES
                      ];
    }
    if(timerEndTime != nil) {
        [timerEndTime release];
        timerEndTime = nil;
    }
    timerEndTime = [[NSDate dateWithTimeIntervalSinceNow:TIME_LIMIT] retain];
}

- (void)stopTimer {
    [pieceTimer invalidate];
    pieceTimer = nil;
    [timerEndTime release];
    timerEndTime = nil;
}

- (void)timerFired {
    NSTimeInterval remaining = [timerEndTime timeIntervalSinceNow];
    if(remaining > 0.0) {
        float progress = remaining / TIME_LIMIT;
        [timerView setProgress:progress];
    } else {
        [self stopTimer];
        [self missedPiece];
    }
}

- (void)missedPiece {
    [self updateScore:-7];
    [self pickNextPiece];
}

- (void)updateScore:(NSInteger)delta {
    currentScore += delta;
    [[self scoreView] setText:[numberFormatter stringFromNumber:[NSNumber numberWithInteger:currentScore]]];
}

- (void)pickNextPiece {
    if([remainingPieces count] > 0) {
        currentPiece = [remainingPieces lastObject];
        [thisPieceView displayPiece:currentPiece];
        [remainingPieces removeLastObject];
        if([remainingPieces count] > 0) {
            [nextPieceView displayPiece:[remainingPieces lastObject]];
            if([remainingPieces count] > 1) {
                [nextNextPieceView displayPiece:[remainingPieces objectAtIndex:([remainingPieces count] - 2)]];
            } else {
                [nextNextPieceView clear];
            }
        } else {
            [nextPieceView clear];
        }
        [self startTimer];
    } else {
        [thisPieceView clear];
        currentPiece = nil;
        [self gameOver];
    }
}

- (void)fillRemainingPieces {
    NSMutableArray *newPieces = [NSMutableArray arrayWithArray:allPieces];
    srandomdev();
    for (NSInteger i = [newPieces count] - 1; i > 0; --i) {
        [newPieces exchangeObjectAtIndex: random() % (i + 1) withObjectAtIndex: i]; 
    }
    if(remainingPieces == nil) {
        remainingPieces = [[NSMutableArray alloc] init];
    }
    [remainingPieces addObjectsFromArray:newPieces];
}

- (NSInteger)findScoreForBoard:(NSInteger *)board {
    NSInteger totalScore = 0;
    NSInteger i, tempBoard, score, bits;
    do {
        i = 1;
        tempBoard = *board >> 1;
        score = 0;
        bits = 0;
        while(tempBoard != 0) {
            int tBits = -1;
            int tScore = 0;
            if(currentScore >= 0 && (tempBoard & MASK_HACKER) == MASK_HACKER && (~tempBoard & MASK_HACKER_INVERSE) == MASK_HACKER_INVERSE) {
                int t = MASK_HACKER << i;
                if(!STRADDLING_EDGES(t)) {
                    [self unlockAward:AWARD_MADE_HACKER];
                }
            }
            if((tempBoard & MASK_3x3) == MASK_3x3) {
                int t = MASK_3x3 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = SCORE_3x3;
                    goto loop;
                }
            }
            if((tempBoard & MASK_3x2) == MASK_3x2) {
                int t = MASK_3x2 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = SCORE_2x3;
                    goto loop;
                }
            }
            if((tempBoard & MASK_2x3) == MASK_2x3) {
                int t = MASK_2x3 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = SCORE_2x3;
                    goto loop;
                }
            }
            if((tempBoard & MASK_2x2) == MASK_2x2) {
                int t = MASK_2x2 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = SCORE_2x2;
                    goto loop;
                }
            }
        loop:
            if(tBits != -1) {
                if(tScore > score) {
                    bits = tBits;
                    score = tScore;
                }
            }
            ++i;
            tempBoard = tempBoard >> 1;
        }
        *board = (*board ^ bits);
        totalScore += score;
        if(score == SCORE_2x2) {
            [self unlockAward:AWARD_MADE_2x2];
        } else if(score == SCORE_2x3) {
            [self unlockAward:AWARD_MADE_2x3];
        } else if(score == SCORE_3x3) {
            [self unlockAward:AWARD_MADE_3x3];
        }
    } while (bits != 0);
    return totalScore;
}

- (void)gameOver {
    isPaused = YES;
    [self stopTimer];
    [thisPieceView clear];
    [nextPieceView clear];
    [nextNextPieceView clear];
    [self submitScore];
    NSLog(@"gameOver");
    [finalScoreView setText:[numberFormatter stringFromNumber:[NSNumber numberWithInteger:currentScore]]];
    [gameOverView setAlpha:0.0];
    [[self view] addSubview:gameOverView];
    [UIView beginAnimations:@"ShowGameOver" context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [gameOverView setAlpha:1.0];
    [UIView commitAnimations];
}

- (NSString *)leaderboardType {
    return LEADERBOARD_CLASSIC;
}

- (void)submitScore {
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:[self leaderboardType]] autorelease];
    scoreReporter.value = currentScore;
    [[KBGameCenter shared] submitScore:scoreReporter];
}

- (void)showMenu {
    MainMenuController *menu = [[MainMenuController alloc] initWithNibName:@"MainMenu" bundle:nil];
    [[[self view] superview] addSubview:[menu view]];
    [[self view] removeFromSuperview];
    [self release];
}

- (void)pause {
    if(isPaused) return;
    isPaused = YES;
    [pieceTimer invalidate];
    pieceTimer = nil;
    pauseTimeRemaining = [timerEndTime timeIntervalSinceNow];
    [gameBoard hide];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused"
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"Continue"
                     otherButtonTitles:@"End game", nil
     ];
    [alert show];
    [alert release];
}

- (void)unpause {
    if(!isPaused) return;
    isPaused = NO;
    [gameBoard unhide];
    [self startTimer];
    [timerEndTime release];
    timerEndTime = [[NSDate dateWithTimeIntervalSinceNow:pauseTimeRemaining] retain];
}

- (void)unlockAward:(NSString *)awardID {
    if([[KBGameCenter shared] hasAchievement:awardID]) return;
    [[KBGameCenter shared] unlockAchievement:awardID];
}

- (void)resetGame {
    isPaused = NO;
    currentScore = 0;
    [scoreView setText:@"0"];
    [gameBoard clear];
    remainingPieces = nil;
    [self fillRemainingPieces];
    [[self timerView] setProgress:1.0];
    [self pickNextPiece];
}

- (void)retry {
    [self resetGame];
    [UIView beginAnimations:@"HideGameOver" context:nil];
    [UIView setAnimationDelegate:gameOverView];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [gameOverView setAlpha:0.0];
    [UIView commitAnimations];
}

- (void)showHighScores {
    GKLeaderboardViewController *leaderboard = [[GKLeaderboardViewController alloc] init];
    if(leaderboard != nil) {
        leaderboard.leaderboardDelegate = self;
        leaderboard.category = self.leaderboardType;
        [self presentModalViewController:leaderboard animated:YES];
    }
    [leaderboard release];
}

- (void)skipPiece {
    if(isPaused) return;
    [self stopTimer];
    [self missedPiece];
}

#pragma mark GKLeaderboardViewControllerDelegate

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == [alertView cancelButtonIndex]) {
        [self unpause];
    } else {
        [self gameOver];
    }
}

#pragma mark UIViewController

- (void)prepare {
    allPieces = [[self loadBitrisPieces] retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setUsesGroupingSeparator:YES];
    [gameBoard setDelegate:self];
    [timerView setDelegate:self];
    [timerView setSelector:@selector(skipPiece)];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.gameBoard = nil;
    self.nextPieceView = nil;
    self.thisPieceView = nil;
    self.nextNextPieceView = nil;
    self.scoreView = nil;
    self.timerView = nil;
    self.finalScoreView = nil;
    self.gameOverView = nil;
}


- (void)dealloc {
    NSLog(@"GameController dealloc.");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [pieceTimer invalidate];
    [gameBoard release];
    [allPieces release];
    [remainingPieces release];
    [numberFormatter release];
    
    [thisPieceView release];
    [nextPieceView release];
    [nextNextPieceView release];
    [scoreView release];
    [finalScoreView release];
    [gameOverView release];
    
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self pause];
}

#pragma mark BitrisBoardDelegate

- (void)touchedCellNumber:(ushort)cell {
    if(isPaused) return;
    [gameBoard previewPiece:currentPiece atCell:cell];
}

- (void)confirmedCellNumber:(ushort)cell {
    if(isPaused) return;
    NSInteger bitmask = [currentPiece getBitmaskForCell:cell];
    if(ON_BOARD(bitmask) && ([gameBoard currentBoard] & bitmask) == 0) {
        NSInteger board = ([gameBoard currentBoard] | bitmask);
        currentPiece = nil;
        [gameBoard renderBoardWithAnimation:board];
        NSInteger score = [self findScoreForBoard:&board];
        if(score > 0) {
            // Get this to animate nicely.
            [gameBoard renderBoardWithAnimation:board];
            [self updateScore:score];
        }
        [self pickNextPiece];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    [gameBoard clearPreview];
}

- (void)movedFromCellNumber:(ushort)oldCell toCellNumber:(ushort)newCell {
    if(isPaused) return;
    [gameBoard clearPreview];
    [gameBoard previewPiece:currentPiece atCell:newCell];
}

- (void)abandonedCell:(ushort)cell {
    if(isPaused) return;
    [gameBoard clearPreview];
}

@end
