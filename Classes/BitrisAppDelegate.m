//
//  BitrisAppDelegate.m
//  Bitris
//
//  Created by Katharine Berry on 28/01/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BitrisAppDelegate.h"
#import "KBGameCenter.h"

@implementation BitrisAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    srandomdev();
    [self authenticateLocalPlayer];
    MainMenuController *firstController = [[MainMenuController alloc] initWithNibName:@"MainMenu" bundle:nil];
    [window addSubview:[firstController view]];
    [window makeKeyAndVisible];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Entering background.");
    [[KBGameCenter shared] storeCache];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"What?");
}

- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if([localPlayer isAuthenticated]) {
            playerID = [[localPlayer playerID] retain];
            NSLog(@"Authenticated (%@).", [error description]);
            [[KBGameCenter shared] submitQueue];
            [[KBGameCenter shared] updateAchievements];
        } else {
            if(playerID)
                [playerID release];
            NSLog(@"Authentication failed: %@", [error description]);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GKAuthenticationChanged" object:localPlayer];
    }];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
