//
//  KBCircularProgressView.h
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KBCircularProgressView : UIView {
    float progress;
}

- (void)setProgress:(float)newProgress;
- (float)progress;

@end
