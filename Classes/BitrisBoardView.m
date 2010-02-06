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

- (void)clear {
    for(int i = 0; i < 25; ++i) {
        BitrisCellView *cell = [cells objectAtIndex:i];
        [cell setAlpha:1.0];
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
    currentBoard = 0;
    currentCell = 0;
}

- (void)createSubviews {
    CGRect frame = [self frame];
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
    [UIView beginAnimations:@"boardrender" context:nil];
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
    if(location.x > [self frame].size.width || location.y > [self frame].size.height) {
        return -1;
    }
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
    if(currentCell <= 25 && currentCell > 0) {
        [delegate confirmedCellNumber:currentCell];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(currentCell <= 25 && currentCell > 0) {
        if([delegate respondsToSelector:@selector(abandonedCell:)])
            [delegate abandonedCell:currentCell];
    }
}

- (BOOL)setAlpha:(CGFloat)opacity onEmptyBitmask:(NSUInteger)bitmask {
    int i;
    for(i = 1; i <= 25; ++i) {
        if((0x1 << i) & bitmask) {
            CGFloat multiplier = ((0x1 << i) & currentBoard) ? 0.5 : 1.0;
            [(BitrisCellView *)[cells objectAtIndex:(i-1)] setAlpha:1 - ((1 - opacity) * multiplier)];
        }
    }
    return ((~currentBoard & bitmask) == bitmask);
}

- (void)setAlpha:(CGFloat)opacity onBitmask:(NSUInteger)bitmask {
    int i;
    for(i = 1; i <= 25; ++i) {
        if((0x1 << i) & bitmask) {
            [(BitrisCellView *)[cells objectAtIndex:(i-1)] setAlpha:opacity];
        }
    }
}

- (BOOL)previewPiece:(BitrisPiece *)piece atCell:(ushort)cell {
    NSUInteger positionedPiece = PIECE_TO_BOARD(piece, cell);
    if(!ON_BOARD(positionedPiece)) return NO;
    BOOL valid = [self setAlpha:0.0 onEmptyBitmask:positionedPiece];
    if(valid) {
        [self setBackgroundColor:[UIColor greenColor]];
    } else {
        [self setBackgroundColor:[UIColor redColor]];
    }
    return valid;
}

- (void)clearPreviewOfPiece:(BitrisPiece *)piece atCell:(ushort)cell {
    NSUInteger positionedPiece = PIECE_TO_BOARD(piece, cell);
    [self setAlpha:1.0 onBitmask:positionedPiece];
    [self setBackgroundColor:[UIColor yellowColor]];
}

- (void)clearPreview {
    for(NSInteger i = 0; i < 25; ++i) {
        [(BitrisCellView *)[cells objectAtIndex:i] setAlpha:1.0];
    }
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
