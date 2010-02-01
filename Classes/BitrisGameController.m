//
//  BitrisGameController.m
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisGameController.h"


@implementation BitrisGameController
@synthesize gameBoard;

#pragma mark Stuff

- (ushort)guessIntendedCellForPiece:(BitrisPiece)piece atCell:(ushort)cell {
    NSInteger positionedPiece = piece.bitmask << (cell + (32 - piece.offset));
    if(!ON_BOARD(positionedPiece)) {
        if(positionedPiece <= 0 || (positionedPiece & ~0x3fffffe) != 0) {
            if(cell <= 5) {
                cell += 5;
            } else if(cell > 20) {
                cell -= 5;
            }
        }
        positionedPiece = piece.bitmask << (cell + (32 - piece.offset));
        if(STRADDLING_EDGES(positionedPiece)) {
            if(cell % 5 == 0) {
                cell -= 1;
            } else {
                cell += 1;
            }
        }
    }
    return cell;
}

#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [gameBoard setDelegate:self];
    [gameBoard renderBoardWithAnimation:0xAAAA];
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
}


- (void)dealloc {
    [super dealloc];
    [gameBoard dealloc];
}

#pragma mark BitrisBoardDelegate

- (void)touchedCellNumber:(ushort)cell {
    NSLog(@"Touch started at %hu", cell);
    BitrisPiece piece;
    piece.bitmask = 6210;
    piece.offset = 6;
    cell = [self guessIntendedCellForPiece:piece atCell:cell];
    [gameBoard previewPiece:piece atCell:cell];
}

- (void)confirmedCellNumber:(ushort)cell {
    NSLog(@"Touch ended at %hu", cell);
    BitrisPiece piece;
    piece.bitmask = 6210;
    piece.offset = 6;
    cell = [self guessIntendedCellForPiece:piece atCell:cell];
    [gameBoard clearPreviewOfPiece:piece atCell:cell];
}

- (void)movedFromCellNumber:(ushort)oldCell toCellNumber:(ushort)newCell {
    NSLog(@"Moved from %hu to %hu", oldCell, newCell);
    BitrisPiece piece;
    piece.bitmask = 6210;
    piece.offset = 6;
    oldCell = [self guessIntendedCellForPiece:piece atCell:oldCell];
    newCell = [self guessIntendedCellForPiece:piece atCell:newCell];
    [gameBoard clearPreviewOfPiece:piece atCell:oldCell];
    [gameBoard previewPiece:piece atCell:newCell];
}

- (void)abandonedCell:(ushort)cell {
    NSLog(@"Abandoned cell %hu.", cell);
    BitrisPiece piece;
    piece.bitmask = 6210;
    piece.offset = 6;
    cell = [self guessIntendedCellForPiece:piece atCell:cell];
    [gameBoard clearPreviewOfPiece:piece atCell:cell];
}

@end
