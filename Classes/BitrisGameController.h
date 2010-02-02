//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisBoardView.h"

@interface BitrisGameController : UIViewController <BitrisBoardDelegate> {
    IBOutlet BitrisBoardView *gameBoard;
    NSMutableArray *remainingPieces;
    NSArray *allPieces;
    NSInteger currentPiece;
}

- (ushort)guessIntendedCellForPiece:(BitrisPiece *)piece atCell:(ushort)cell;
- (NSArray *)loadBitrisPieces;
- (IBAction)nextPiece;

@property(retain) IBOutlet BitrisBoardView *gameBoard;
@end
