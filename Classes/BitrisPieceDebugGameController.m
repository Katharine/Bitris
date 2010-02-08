//
//  BitrisPieceDebugGameController.m
//  Bitris
//
//  Created by Katharine Berry on 08/02/2010.
//  Copyright 2010 AjaxLife Developments. All rights reserved.
//

#import "BitrisPieceDebugGameController.h"
#import "BitrisPiece.h"
#import "BitrisBoardView.h"
#import "BitrisPieceView.h"


@implementation BitrisPieceDebugGameController

- (void)confirmedCellNumber:(ushort)cell {
    if(isPaused) return;
    NSInteger bitmask = [currentPiece getBitmaskForCell:cell];
    NSInteger board = [gameBoard currentBoard] ^ bitmask;
    [[self scoreView] setText:[numberFormatter stringFromNumber:[NSNumber numberWithInteger:board]]];
    [gameBoard renderBoardWithAnimation:board];
    [gameBoard clearPreview];
    NSLog(@"Current board: %i", board);
}

- (void)updateScore:(NSInteger)delta {
    // pass.
}

- (void)submitScore {
    // Also pass.
}

- (void)pickNextPiece {
    BitrisPiece *piece = BitrisPieceMake(0x1, 0);
    [thisPieceView displayPiece:piece];
    [nextPieceView displayPiece:piece];
    [nextNextPieceView displayPiece:piece];
    currentPiece = [piece retain];
}

- (void)gameOver {
    [self showMenu];
}

@end
