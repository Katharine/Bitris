//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisBoardView.h"

@interface BitrisGameController : UIViewController <BitrisBoardDelegate> {
    IBOutlet BitrisBoardView *gameBoard;
    NSArray *allPieces;
    NSMutableArray *remainingPieces;
}
@property(retain) IBOutlet BitrisBoardView *gameBoard;
@end
