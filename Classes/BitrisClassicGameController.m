//
//  BitrisClassicGameController.m
//  Bitris
//
//  Created by Katharine Berry on 07/02/2010.
//  Copyright 2010 AjaxLife Developments. All rights reserved.
//

#import "BitrisClassicGameController.h"


@implementation BitrisClassicGameController

- (void)updateScore:(NSInteger)delta {
    [super updateScore:delta];
    if(currentScore >= 100) {
        [self unlockAward:AWARD_CLASSIC_100];
    }
    if(currentScore >= 200) {
        [self unlockAward:AWARD_CLASSIC_200];
    }
    if(currentScore >= 300) {
        [self unlockAward:AWARD_CLASSIC_300];
    }
}

@end
