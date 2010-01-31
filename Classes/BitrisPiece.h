//
//  BitrisPiece.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MASK_3x3 7399
#define MASK_3x2 231
#define MASK_2x3 3171
#define MASK_2x2 99

struct BitrisPiece {
    NSUInteger bitmask;
    ushort offset;
};
typedef struct BitrisPiece BitrisPiece;
