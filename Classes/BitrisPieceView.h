//
//  BitrisPieceView.h
//  Bitris
//
//  Created by Katharine Berry on 02/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisCellView.h"
#import "BitrisPiece.h"


@interface BitrisPieceView : UIView {
    BitrisPiece *currentPiece;
    NSMutableArray *cells;
}

- (void)createSubviews;
- (void)displayPiece:(BitrisPiece *)piece;

@end
