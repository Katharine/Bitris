//
//  KBCircularProgressView.m
//  Bitris
//
//  Created by Katharine Berry on 03/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KBCircularProgressView.h"


@implementation KBCircularProgressView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = [self frame].size;
    float radius = ((size.width > size.height) ? size.height : size.width) / 2.0;
    float x = size.height / 2.0;
    float y = size.width / 2.0;
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius, -M_PI_2 + (M_PI * 2.0 * progress), -M_PI_2, YES);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillPath(context);
}

- (void)setProgress:(float)newProgress {
    progress = newProgress;
    [self setNeedsDisplay];
}

- (float)progress {
    return progress;
}


- (void)dealloc {
    [super dealloc];
}


@end
