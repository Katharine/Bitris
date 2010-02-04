//
//  MainMenuController.h
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGON.h"
#import "BitrisGameController.h"

@interface MainMenuController : UIViewController {

}

- (IBAction)startClassicGame;
- (IBAction)startEndlessGame;
- (IBAction)showLeaderboards;
- (IBAction)showAwards;
- (void)startGameOfType:(BitrisGameType)gameType;

@end
