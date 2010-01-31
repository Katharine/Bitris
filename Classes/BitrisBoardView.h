//
//  BitrisBoardView.h
//  Bitris
//
//  Created by Katharine Berry on 30/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisCellView.h"


@interface BitrisBoardView : UIView {
    NSArray *cells;
    NSUInteger currentBoard;
    ushort currentCell;
}

- (void)createSubviews;
- (void)renderBoardWithAnimation:(NSUInteger)board;
- (void)finishRenderingAnimation:(NSString *)animation finished:(NSNumber *)finished withBoard:(NSUInteger)board;


@property(assign) NSArray *cells;
@property(readonly) NSUInteger currentBoard;

@end
