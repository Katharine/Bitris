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
    IBOutlet UILabel *accountLabel;
}

@property(retain) IBOutlet UILabel *accountLabel;

- (IBAction)startClassicGame;
- (IBAction)startEndlessGame;
- (IBAction)showLeaderboards;
- (IBAction)showAwards;
- (IBAction)changeAccount;
- (IBAction)editProfile;
- (void)profileChanged;
- (void)startGameOfType:(BitrisGameType)gameType;

@end
