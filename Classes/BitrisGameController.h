//
//  BitrisGameController.h
//  Bitris
//
//  Created by Katharine Berry on 31/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitrisBoardView.h"

@interface BitrisGameController : UIViewController {
    IBOutlet BitrisBoardView *gameBoard;
}
@property(retain) IBOutlet BitrisBoardView *gameBoard;
@end
