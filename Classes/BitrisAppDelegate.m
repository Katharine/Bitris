//
//  BitrisAppDelegate.m
//  Bitris
//
//  Created by Katharine Berry on 28/01/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BitrisAppDelegate.h"

@implementation BitrisAppDelegate

@synthesize window, firstController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window addSubview:[firstController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
