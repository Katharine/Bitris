//
//  BitrisAppDelegate.m
//  Bitris
//
//  Created by Katharine Berry on 28/01/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BitrisAppDelegate.h"

@implementation BitrisAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    if(!AgonCreate(@"2D93FFBE4ECA914C356E87EB53D8E4DDF4B46888", AgonDeveloperServers)) {
        NSLog(@"AGON initialisation failed.");
    } else {
        NSLog(@"AGON initialised.");
    }
    
    MainMenuController *firstController = [[MainMenuController alloc] initWithNibName:@"MainMenu" bundle:nil];
    [window addSubview:[firstController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
