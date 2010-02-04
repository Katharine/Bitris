//
//  MainMenuController.m
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"

@implementation MainMenuController

- (void)startGameOfType:(BitrisGameType)gameType {
    BitrisGameController *gameScreen = [[BitrisGameController alloc] initWithNibName:@"MainGame" bundle:nil];
    [gameScreen setGameType:gameType];
    [[[self view] superview] addSubview:[gameScreen view]];
    [[self view] removeFromSuperview];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    NSLog(@"Menu dealloc.");
    [super dealloc];
}


@end
