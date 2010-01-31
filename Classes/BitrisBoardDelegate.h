//
//  BitrisBoardDelegate.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BitrisBoardDelegate <NSObject>

- (void)touchedCellNumber:(ushort)cell;
- (void)confirmedCellNumber:(ushort)cell;

@optional
- (void)movedFromCellNumber:(ushort)oldCell toCellNumber:(ushort)newCell;
- (void)abandonedCell:(ushort)cell;
@end
