//
//  BitrisGameController.m
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisGameController.h"


@implementation BitrisGameController
@synthesize gameBoard, thisPieceView, nextPieceView, nextNextPieceView, scoreView, timerView;

#pragma mark Stuff

- (ushort)guessIntendedCellForPiece:(BitrisPiece *)piece atCell:(ushort)cell {
    // Stuff this.
    /*
    NSInteger positionedPiece = PIECE_TO_BOARD(piece, cell);
    NSLog(@"%i", positionedPiece);
    if(!ON_BOARD(positionedPiece)) {
        if(positionedPiece < 0 || (positionedPiece & ~VALID_CELLS) != 0) {
            if(cell <= 5) {
                cell += 5;
            } else if(cell > 20) {
                cell -= 5;
            }
        }
        positionedPiece = PIECE_TO_BOARD(piece, cell);
        if(STRADDLING_EDGES(positionedPiece)) {
            if(cell % 5 == 0) {
                cell -= 1;
            } else {
                cell += 1;
            }
        }
    }
    return cell;
     */
    return cell;
}

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
    timerEndTime = [[NSDate dateWithTimeIntervalSinceNow:20.0] retain];
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
        float progress = remaining / 20.0;
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
    [[self scoreView] setText:[[NSNumber numberWithInteger:currentScore] stringValue]];
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
    }
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
            if((tempBoard & MASK_3x3) == MASK_3x3) {
                int t = MASK_3x3 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = 30;
                    goto loop;
                }
            }
            if((tempBoard & MASK_3x2) == MASK_3x2) {
                int t = MASK_3x2 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = 15;
                    goto loop;
                }
            }
            if((tempBoard & MASK_2x3) == MASK_2x3) {
                int t = MASK_2x3 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = 15;
                    goto loop;
                }
            }
            if((tempBoard & MASK_2x2) == MASK_2x2) {
                int t = MASK_2x2 << i;
                if(!STRADDLING_EDGES(t)) {
                    tBits = t;
                    tScore = 5;
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
    } while (bits != 0);
    return totalScore;
}

- (void)gameOver {
    // Do something useful here.
    [self stopTimer];
    [self pickNextPiece];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game over!" message:[NSString stringWithFormat:@"You scored %i!\n(Put something useful here)", currentScore, nil] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [gameBoard setDelegate:self];
    allPieces = [[self loadBitrisPieces] retain];
    remainingPieces = [[NSMutableArray arrayWithArray:allPieces] retain];
    currentScore = 0;
    // Shuffle it.
    srandomdev();
    for (NSInteger i = [remainingPieces count] - 1; i > 0; --i) {
        [remainingPieces exchangeObjectAtIndex: random() % (i + 1) withObjectAtIndex: i]; 
    }
    [[self timerView] setProgress:1.0];
    [self pickNextPiece];
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
}


- (void)dealloc {
    [super dealloc];
    [pieceTimer invalidate];
    [gameBoard release];
    [allPieces release];
    [remainingPieces release];
    [thisPieceView release];
    [nextPieceView release];
    [nextNextPieceView release];
    [scoreView release];
}

#pragma mark BitrisBoardDelegate

- (void)touchedCellNumber:(ushort)cell {
    cell = [self guessIntendedCellForPiece:currentPiece atCell:cell];
    [gameBoard previewPiece:currentPiece atCell:cell];
}

- (void)confirmedCellNumber:(ushort)cell {
    cell = [self guessIntendedCellForPiece:currentPiece atCell:cell];
    NSInteger bitmask = [currentPiece getBitmaskForCell:cell];
    if(ON_BOARD(bitmask) && ([gameBoard currentBoard] & bitmask) == 0) {
        NSInteger board = ([gameBoard currentBoard] | bitmask);
        [gameBoard renderBoardWithAnimation:board];
        NSInteger score = [self findScoreForBoard:&board];
        if(score > 0) {
            // Get this to animate nicely.
            [gameBoard renderBoardWithAnimation:board];
            [self updateScore:score];
        }
        if([remainingPieces count] > 0) {
            [self pickNextPiece];
        } else {
            [self gameOver];
        }
    } else {
        [gameBoard clearPreviewOfPiece:currentPiece atCell:cell];
    }
}

- (void)movedFromCellNumber:(ushort)oldCell toCellNumber:(ushort)newCell {
    oldCell = [self guessIntendedCellForPiece:currentPiece atCell:oldCell];
    newCell = [self guessIntendedCellForPiece:currentPiece atCell:newCell];
    [gameBoard clearPreviewOfPiece:currentPiece atCell:oldCell];
    [gameBoard previewPiece:currentPiece atCell:newCell];
}

- (void)abandonedCell:(ushort)cell {
    cell = [self guessIntendedCellForPiece:currentPiece atCell:cell];
    [gameBoard clearPreviewOfPiece:currentPiece atCell:cell];
}

@end
