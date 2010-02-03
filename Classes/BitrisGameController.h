//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisBoardView.h"
#import "BitrisPieceView.h"

@interface BitrisGameController : UIViewController <BitrisBoardDelegate> {
    IBOutlet BitrisBoardView *gameBoard;
    IBOutlet BitrisPieceView *thisPieceView;
    IBOutlet BitrisPieceView *nextPieceView;
    IBOutlet BitrisPieceView *nextNextPieceView;
    IBOutlet UILabel *scoreView;
    NSMutableArray *remainingPieces;
    NSArray *allPieces;
    BitrisPiece *currentPiece;
    NSInteger currentScore;
}

- (ushort)guessIntendedCellForPiece:(BitrisPiece *)piece atCell:(ushort)cell;
- (NSArray *)loadBitrisPieces;
- (void)pickNextPiece;

@property(retain) IBOutlet BitrisBoardView *gameBoard;
@property(retain) IBOutlet BitrisPieceView *thisPieceView;
@property(retain) IBOutlet BitrisPieceView *nextPieceView;
@property(retain) IBOutlet BitrisPieceView *nextNextPieceView;
@property(retain) IBOutlet UILabel *scoreView;
@end
