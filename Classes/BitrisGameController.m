//
//  BitrisGameController.m
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisGameController.h"


@implementation BitrisGameController
@synthesize gameBoard, thisPieceView, nextPieceView;

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
             nil]
            retain];
}

- (IBAction)nextPiece {
    if(++currentPiece >= [allPieces count]) {
        currentPiece = 0;
    }
    [thisPieceView displayPiece:[allPieces objectAtIndex:currentPiece]];
    [nextPieceView displayPiece:[allPieces objectAtIndex:((currentPiece + 1) % [allPieces count])]];
}

#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [gameBoard setDelegate:self];
    allPieces = [self loadBitrisPieces];
    [gameBoard renderBoardWithAnimation:0xAAAA];
    [thisPieceView displayPiece:[allPieces objectAtIndex:currentPiece]];
    [nextPieceView displayPiece:[allPieces objectAtIndex:((currentPiece + 1) % [allPieces count])]];
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
}


- (void)dealloc {
    [super dealloc];
    [gameBoard release];
    [allPieces release];
    [thisPieceView release];
    [nextPieceView release];
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
