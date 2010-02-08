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
    AgonShow(AgonBladeLeaderboards, YES);
}

- (IBAction)showAwards {
    AgonShow(AgonBladeAwards, YES);
}

- (IBAction)changeAccount {
    AgonShowProfilePicker();
}

- (IBAction)editProfile {
    AgonShow(AgonBladeProfile, NO);
}

- (IBAction)startMultiplayerGame {
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    [picker show];
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
    GKSession *session = [[GKSession alloc] initWithSessionID:nil displayName:AgonGetActiveProfileUserName() sessionMode:GKSessionModePeer];
    return [session autorelease];
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [self profileChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileChanged) name:AGONProfileChangedNotification object:nil];
}

- (void)profileChanged {
    [accountLabel setText:[NSString stringWithFormat:@"You are logged in as %@.", AgonGetActiveProfileUserName(),nil]];
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
