//
//  MainMenuController.h
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MainMenuController : UIViewController <GKPeerPickerControllerDelegate, GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate> {
    IBOutlet UIButton *highScoreButton;
    IBOutlet UIButton *achievementsButton;
}

@property(retain) IBOutlet UILabel *accountLabel;

- (IBAction)startClassicGame;
- (IBAction)startEndlessGame;
- (IBAction)showLeaderboards;
- (IBAction)showAchievements;
- (IBAction)startMultiplayerGame;
- (IBAction)startDebugGame;
- (void)startGameWithController:(Class)gameType;

@end
