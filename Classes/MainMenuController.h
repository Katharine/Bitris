//
//  MainMenuController.h
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "AGON.h"

@interface MainMenuController : UIViewController <GKPeerPickerControllerDelegate> {
    IBOutlet UILabel *accountLabel;
}

@property(retain) IBOutlet UILabel *accountLabel;

- (IBAction)startClassicGame;
- (IBAction)startEndlessGame;
- (IBAction)showLeaderboards;
- (IBAction)showAwards;
- (IBAction)changeAccount;
- (IBAction)editProfile;
- (IBAction)startMultiplayerGame;
- (IBAction)startDebugGame;
- (void)profileChanged;
- (void)startGameWithController:(Class)gameType;

@end
