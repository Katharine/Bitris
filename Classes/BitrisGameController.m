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
    return [[NSArray arrayWithObjects:
            BitrisPieceMake(6276, 7),
            BitrisPieceMake(6210, 6),
            BitrisPieceMake(458, 7),
            BitrisPieceMake(14, 2),
            BitrisPieceMake(142, 2),
            BitrisPieceMake(452, 7),
            BitrisPieceMake(2242, 6),
            BitrisPieceMake(4292, 7),
            BitrisPieceMake(1, 0),
            BitrisPieceMake(8322, 7),
            BitrisPieceMake(2184, 7),
            BitrisPieceMake(10378, 7),
            BitrisPieceMake(4548, 7),
            BitrisPieceMake(194, 6),
            BitrisPieceMake(196, 7),
            BitrisPieceMake(68, 2),
            BitrisPieceMake(66, 1),
            BitrisPieceMake(6, 1),
            BitrisPieceMake(334, 2),
            BitrisPieceMake(6214, 6),
            BitrisPieceMake(134, 2),
            BitrisPieceMake(70, 1),
            BitrisPieceMake(6278, 7),
            BitrisPieceMake(4290, 7),
            BitrisPieceMake(2244, 6),
            BitrisPieceMake(390, 7),
            BitrisPieceMake(204, 7),
            BitrisPieceMake(78, 2),
            BitrisPieceMake(4230, 7),
            BitrisPieceMake(456, 7),
            BitrisPieceMake(450, 7),
            BitrisPieceMake(2118, 6),
            BitrisPieceMake(270, 2),
            BitrisPieceMake(130, 1),
            BitrisPieceMake(2114, 6),
            nil] retain];
}

- (IBAction)nextPiece {
    if(currentPiece++ >= [allPieces count]) {
        currentPiece = 0;
    }
}

#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [gameBoard setDelegate:self];
    allPieces = [self loadBitrisPieces];
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
    [gameBoard release];
    [allPieces release];
}

#pragma mark BitrisBoardDelegate

- (void)touchedCellNumber:(ushort)cell {
    cell = [self guessIntendedCellForPiece:[allPieces objectAtIndex:currentPiece] atCell:cell];
    [gameBoard previewPiece:[allPieces objectAtIndex:currentPiece] atCell:cell];
}

- (void)confirmedCellNumber:(ushort)cell {
    cell = [self guessIntendedCellForPiece:[allPieces objectAtIndex:currentPiece] atCell:cell];
    [gameBoard clearPreviewOfPiece:[allPieces objectAtIndex:currentPiece] atCell:cell];
}

- (void)movedFromCellNumber:(ushort)oldCell toCellNumber:(ushort)newCell {
    oldCell = [self guessIntendedCellForPiece:[allPieces objectAtIndex:currentPiece] atCell:oldCell];
    newCell = [self guessIntendedCellForPiece:[allPieces objectAtIndex:currentPiece] atCell:newCell];
    [gameBoard clearPreviewOfPiece:[allPieces objectAtIndex:currentPiece] atCell:oldCell];
    [gameBoard previewPiece:[allPieces objectAtIndex:currentPiece] atCell:newCell];
}

- (void)abandonedCell:(ushort)cell {
    cell = [self guessIntendedCellForPiece:[allPieces objectAtIndex:currentPiece] atCell:cell];
    [gameBoard clearPreviewOfPiece:[allPieces objectAtIndex:currentPiece] atCell:cell];
}

@end
