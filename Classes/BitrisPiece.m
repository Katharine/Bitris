/*
 *  BitrisPiece.c
 *  Bitris
 *
 *  Created by Katharine Berry on 01/02/2010.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import "BitrisPiece.h"

@implementation BitrisPiece
@synthesize bitmask, offset;

- (NSInteger)getBitmaskForCell:(ushort)cell {
    return PIECE_TO_BOARD(self, cell);
}

- (BitrisPiece *)initWithBitmask:(NSInteger)theBitmask andOffset:(ushort)theOffset {
    [super init];
    bitmask = theBitmask;
    offset = theOffset;
    return self;
}

@end


BitrisPiece* BitrisPieceMake(NSInteger bitmask, ushort offset) {
    return [[BitrisPiece alloc] initWithBitmask:bitmask andOffset:offset];
}