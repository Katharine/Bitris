//
//  BitrisBoardView.h
//  Bitris
//
//  Created by Katharine Berry on 30/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisCellView.h"
#import "BitrisBoardDelegate.h"
#import "BitrisPiece.h"


@interface BitrisBoardView : UIView {
    NSArray *cells;
    NSUInteger currentBoard;
    short currentCell;
    id<BitrisBoardDelegate> delegate;
}

- (void)createSubviews;
- (void)renderBoardWithAnimation:(NSUInteger)board;
- (BOOL)setAlpha:(CGFloat)opacity onEmptyBitmask:(NSUInteger)bitmask;
- (BOOL)previewPiece:(BitrisPiece *)piece atCell:(ushort)cell;
- (void)clearPreviewOfPiece:(BitrisPiece *)piece atCell:(ushort)cell;
- (void)clearPreview;

@property(assign) NSArray *cells;
@property(readonly) NSUInteger currentBoard;
@property(retain) id<BitrisBoardDelegate> delegate;

@end
