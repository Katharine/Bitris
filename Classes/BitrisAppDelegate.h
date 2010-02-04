//
//  BitrisAppDelegate.h
//  Bitris
//
//  Created by Katharine Berry on 28/01/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGON.h"
#import "MainMenuController.h"

@interface BitrisAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

