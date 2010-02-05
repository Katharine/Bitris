//
//  MainMenuController.m
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"

@implementation MainMenuController
@synthesize accountLabel;

- (void)startGameOfType:(BitrisGameType)gameType {
    BitrisGameController *gameScreen = [[BitrisGameController alloc] initWithNibName:@"MainGame" bundle:nil];
    [gameScreen setGameType:gameType];
    [[[self view] superview] addSubview:[gameScreen view]];
    [[self view] removeFromSuperview];
    [self release];
}

- (IBAction)startClassicGame {
    [self startGameOfType:BitrisGameClassic];
}

- (IBAction)startEndlessGame {
    [self startGameOfType:BitrisGameEndless];
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
