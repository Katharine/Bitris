//
//  BitrisAppDelegate.h
//  Bitris
//
//  Created by Katharine Berry on 28/01/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BitrisAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IBOutlet UIViewController *firstController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *firstController;

@end

