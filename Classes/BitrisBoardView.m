//
//  BitrisBoardView.m
//  Bitris
//
//  Created by Katharine Berry on 30/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisBoardView.h"

@implementation BitrisBoardView
@synthesize cells, currentBoard;


- (void)createSubviews {
    CGRect frame = [self frame];
    NSLog(@"BitrisBoardView subview creation.");
    NSMutableArray *mutableCells = [[[NSMutableArray alloc] init] autorelease];
    ushort i;
    int width = frame.size.width / 5;
    int height = frame.size.height / 5;
    for(i = 0; i < 25; ++i) {
        BitrisCellView *cell = [[BitrisCellView alloc] initWithFrame:
                                CGRectMake((i % 5) * width, (i / 5) * height, width, height)];
        [cell setCellNumber:i];
        [self addSubview:cell];
        [mutableCells addObject:cell];
    }
    self.cells = [[NSArray arrayWithArray:mutableCells] retain];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = [self frame].size;
    int verticalSpacing = size.height / 5;
    int horizontalSpacing = size.width / 5;
    int i;
    for(i = 0; i <= 5; ++i) {
        CGContextMoveToPoint(context, i * horizontalSpacing, 0);
        CGContextAddLineToPoint(context, i * horizontalSpacing, size.height);
        CGContextMoveToPoint(context, 0, i * verticalSpacing);
        CGContextAddLineToPoint(context, size.width, i * verticalSpacing);
    }
    CGContextSetLineWidth(context, 5.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextStrokePath(context);
}

- (void)renderBoardWithAnimation:(NSUInteger)board {
    int i;
    [UIView beginAnimations:@"render" context:(void *)board];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    for(i = 0; i < 25; ++i) {
        BitrisCellView *cell = [[self cells] objectAtIndex:i];
        NSUInteger shifted = 1 << i;
        if(board & shifted) {
            if(~currentBoard & shifted) [cell setAlpha:0.0];
        } else {
            if(currentBoard & shifted) [cell setAlpha:0.0];
        }
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishRenderingAnimation:finished:withBoard:)];
    [UIView commitAnimations];
}

- (void)finishRenderingAnimation:(NSString *)animation finished:(NSNumber *)finished withBoard:(NSUInteger)board {
    [UIView beginAnimations:@"finishrender" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    int i;
    for(i = 0; i < 25; ++i) {
        BitrisCellView *cell = [[self cells] objectAtIndex:i];
        NSUInteger shifted = 1 << i;
        if(board & shifted) {
            if(~currentBoard & shifted) {
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setAlpha:1.0];
            }
        } else {
            if(currentBoard & shifted) {
                [cell setBackgroundColor:[UIColor lightGrayColor]];
                [cell setAlpha:1.0];
            }
        }
    }
    [UIView commitAnimations];
}

- (ushort)findCellNumberAtPoint:(CGPoint)location {
    ushort column = location.x / ([self frame].size.width / 5);
    ushort row = location.y / ([self frame].size.height / 5);
    return row * 5 + column;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    currentCell = [self findCellNumberAtPoint:[(UITouch *)[touches anyObject] locationInView:self]];
    NSLog(@"Started at %hu", currentCell);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    ushort cell = [self findCellNumberAtPoint:[(UITouch *)[touches anyObject] locationInView:self]];
    if(cell != currentCell) {
        currentCell = cell;
        NSLog(@"Moved to %hu", currentCell);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    currentCell = [self findCellNumberAtPoint:[(UITouch *)[touches anyObject] locationInView:self]];
    NSLog(@"Ended at %hu", currentCell);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches cancelled.");
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [cells release];
}


@end
