//
//  MainMenuController.m
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"
#import "BitrisGameController.h"
#import "BitrisEndlessGameController.h"
#import "BitrisClassicGameController.h"
#import "BitrisPieceDebugGameController.h"

@implementation MainMenuController
@synthesize accountLabel;

- (void)startGameWithController:(Class)gameController {
    BitrisGameController *gameScreen = [[gameController alloc] initWithNibName:@"MainGame" bundle:nil];
    [[[self view] superview] addSubview:[gameScreen view]];
    [[self view] removeFromSuperview];
    [self release];
    [gameScreen prepare];
    [gameScreen resetGame];
}

- (IBAction)startClassicGame {
    [self startGameWithController:[BitrisClassicGameController class]];
}

- (IBAction)startEndlessGame {
    [self startGameWithController:[BitrisEndlessGameController class]];
}

- (IBAction)startDebugGame {
    [self startGameWithController:[BitrisPieceDebugGameController class]];
}

- (IBAction)showLeaderboards {
    GKLeaderboardViewController *leaderboard = [[GKLeaderboardViewController alloc] init];
    if(leaderboard != nil) {
        leaderboard.leaderboardDelegate = self;
        [self presentModalViewController:leaderboard animated:YES];
    }
    [leaderboard release];
}

- (IBAction)showAchievements {
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if(achievements != nil) {
        achievements.achievementDelegate = self;
        [self presentModalViewController:achievements animated:YES];
    }
    [achievements release];
}

- (IBAction)startMultiplayerGame {
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    [picker show];
}

#pragma mark GKLeaderboardViewControllerDelegate

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)leaderboard {
    [leaderboard dismissModalViewControllerAnimated:YES];
}

#pragma mark GKAchievementViewControllerDelegate

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark GKPeerPickerControllerDelegate

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    picker.delegate = nil;
    [picker release];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    // Show multiplayer menu.
    picker.delegate = nil;
    [picker dismiss];
    [picker release];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    NSString *displayName = [[GKLocalPlayer localPlayer] alias];
    GKSession *session = [[GKSession alloc] initWithSessionID:nil displayName:displayName sessionMode:GKSessionModePeer];
    return [session autorelease];
}

- (void)updateGKButtons {
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    [achievementsButton setEnabled:[player isAuthenticated]];
    [highScoreButton setEnabled:[player isAuthenticated]];
}

#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [self updateGKButtons];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGKButtons) name:@"GKAuthenticationChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.accountLabel = nil;
}


- (void)dealloc {
    NSLog(@"Menu dealloc");
    [accountLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end
