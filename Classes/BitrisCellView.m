//
//  BitrisCellView.m
//  Bitris
//
//  Created by Katharine Berry on 30/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisCellView.h"


@implementation BitrisCellView
@synthesize cellNumber;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Setup
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = [self frame];
    
    // Highlight
    CGContextSetFillColorWithColor(context, [[[UIColor whiteColor] colorWithAlphaComponent:0.4] CGColor]);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, frame.size.width / 2, frame.size.height / -2, frame.size.width, 0, M_PI, NO);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
    
    // Border
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context, frame.size.width / 10.0);
    CGContextStrokeRect(context, rect);
}


- (void)dealloc {
    [super dealloc];
}


@end
