//
//  BitrisBoardView.m
//  Bitris
//
//  Created by Katharine Berry on 30/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BitrisBoardView.h"

@implementation BitrisBoardView
@synthesize cells, currentBoard, delegate;


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
    for(i = 1; i <= 25; ++i) {
        BitrisCellView *cell = [[self cells] objectAtIndex:i - 1];
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
    for(i = 1; i <= 25; ++i) {
        BitrisCellView *cell = [[self cells] objectAtIndex:i - 1];
        NSUInteger shifted = 1 << i;
        if(board & shifted) {
            if(~currentBoard & shifted) {
                [cell setBackgroundColor:[UIColor orangeColor]];
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
    currentBoard = board;
}

- (ushort)findCellNumberAtPoint:(CGPoint)location {
    short column = location.x / ([self frame].size.width / 5);
    short row = location.y / ([self frame].size.height / 5);
    return row * 5 + column + 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    currentCell = [self findCellNumberAtPoint:[(UITouch *)[touches anyObject] locationInView:self]];
    if (currentCell <= 25 && currentCell > 0)
        [delegate touchedCellNumber:currentCell];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    short cell = [self findCellNumberAtPoint:[(UITouch *)[touches anyObject] locationInView:self]];
    if(cell != currentCell) {
        if (currentCell <= 25 && currentCell > 0) {
            if(cell <= 25 && cell > 0) {
                if([delegate respondsToSelector:@selector(movedFromCellNumber:toCellNumber:)])
                    [delegate movedFromCellNumber:currentCell toCellNumber:cell];
            } else {
                if([delegate respondsToSelector:@selector(abandonedCell:)]) {
                    [delegate abandonedCell:currentCell];
                }
            }
        } else {
            if(cell <= 25 && cell > 0)
                [delegate touchedCellNumber:cell];
        }
        currentCell = cell;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    currentCell = [self findCellNumberAtPoint:[(UITouch *)[touches anyObject] locationInView:self]];
    if(currentCell < 25 && currentCell >= 0) {
        [delegate confirmedCellNumber:currentCell];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(currentCell < 25 && currentCell >= 0) {
        if([delegate respondsToSelector:@selector(abandonedCell:)])
            [delegate abandonedCell:currentCell];
    }
}

- (BOOL)setAlpha:(CGFloat)opacity onEmptyBitmask:(NSUInteger)bitmask {
    int i;
    for(i = 1; i <= 25; ++i) {
        if((0x1 << i) & bitmask) {
            [(BitrisCellView *)[cells objectAtIndex:(i-1)] setAlpha:opacity];
        }
    }
    return ((~currentBoard & bitmask) == bitmask);
}

- (BOOL)previewPiece:(BitrisPiece)piece atCell:(ushort)cell {
    NSUInteger positionedPiece = piece.bitmask << (cell + (32 - piece.offset));
    if(positionedPiece > 0 && (positionedPiece & 2080374784) == 0 && 
       (positionedPiece & 96) != 96 && (positionedPiece & 3072) != 3072 && (positionedPiece & 98304) != 98304 && 
       (positionedPiece & 3145728) != 3145728 && (positionedPiece & 34) != 34 && (positionedPiece & 2080) != 2080 && 
       (positionedPiece & 1088) != 1088 && (positionedPiece & 66560) != 66560 && (positionedPiece & 34816) != 34816 && 
       (positionedPiece & 2129920) != 2129920 && (positionedPiece & 1114112) != 1114112 && 
       (positionedPiece & 35651584) != 35651584) {
        BOOL valid = [self setAlpha:0.0 onEmptyBitmask:positionedPiece];
        if(valid) {
            [self setBackgroundColor:[UIColor greenColor]];
        } else {
            [self setBackgroundColor:[UIColor redColor]];
        }
        return valid;
    }
    return NO;
}

- (void)clearPreviewOfPiece:(BitrisPiece)piece atCell:(ushort)cell {
    NSUInteger positionedPiece = piece.bitmask << (cell + (32 - piece.offset));
    [self setAlpha:1.0 onEmptyBitmask:positionedPiece];
    [self setBackgroundColor:[UIColor yellowColor]];
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
