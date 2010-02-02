//
//  BitrisPieceView.m
//  Bitris
//
//  Created by Katharine Berry on 02/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisPieceView.h"


@implementation BitrisPieceView

- (void)createSubviews {
    CGRect frame = [self frame];
    NSMutableArray *mutableCells = [[[NSMutableArray alloc] init] autorelease];
    ushort i;
    int width = frame.size.width / 3;
    int height = frame.size.height / 3;
    for(i = 0; i < 9; ++i) {
        BitrisCellView *cell = [[BitrisCellView alloc] initWithFrame:
                                CGRectMake((i % 3) * width, (i / 3) * height, width, height)];
        [cell setCellNumber:i];
        [self addSubview:cell];
        [mutableCells addObject:cell];
    }
    cells = [[NSArray arrayWithArray:mutableCells] retain];
}

- (void)displayPiece:(BitrisPiece *)piece {
    currentPiece = piece;
    NSInteger bitmask = [piece getBitmaskForCell:7];
    int i, shift;
    for(i = 1; i <= 9; ++i) {
        shift = i;
        if(i > 3) shift += 2;
        if(i > 6) shift += 2;
        if (bitmask & (0x1 << shift)) {
            [[cells objectAtIndex:i-1] setBackgroundColor:[UIColor orangeColor]];
        } else {
            [[cells objectAtIndex:i-1] setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = [self frame].size;
    int verticalSpacing = size.height / 3;
    int horizontalSpacing = size.width / 3;
    int i;
    for(i = 0; i <= 3; ++i) {
        CGContextMoveToPoint(context, i * horizontalSpacing, 0);
        CGContextAddLineToPoint(context, i * horizontalSpacing, size.height);
        CGContextMoveToPoint(context, 0, i * verticalSpacing);
        CGContextAddLineToPoint(context, size.width, i * verticalSpacing);
    }
    CGContextSetLineWidth(context, size.width / 30.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextStrokePath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
