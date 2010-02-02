//
//  BitrisPiece.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MASK_3x3 0x1CE7
#define MASK_3x2 0x00E7
#define MASK_2x3 0x0C63
#define MASK_2x2 0x0063

#define VALID_CELLS 0x3fffffe

#define STRADDLING_EDGES(piece)(((piece) & 0x4210842) && ((piece) & 0x42108421))
#define ON_BOARD(piece) (!STRADDLING_EDGES(piece) && (((piece) & 0x7C000000) == 0) && (piece) > 0)
#define PIECE_TO_BOARD(piece, cell) (piece).bitmask << ((cell) + (32 - (piece).offset))

@interface BitrisPiece : NSObject {
    NSInteger bitmask;
    ushort offset;
}

- (NSInteger)getBitmapForCell:(ushort)cell;

@property(readonly) NSInteger bitmask;
@property(readonly) ushort offset;
@end
    
BitrisPiece * BitrisPieceMake(NSInteger bitmask, ushort offset);