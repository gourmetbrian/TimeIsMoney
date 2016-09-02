//
//  TimeIsMoneySettingsModel.m
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import "TimeIsMoneySettingsModel.h"

@implementation TimeIsMoneySettingsModel

@synthesize userWorkTime;
@synthesize userBreakTime;
@synthesize useLongBreak;
@synthesize tickSoundOn;

-(id) init
{
    self = [super init];

    if(self) {
    //commented out for debugging
    //userWorkTime = 3;
    // userBreakTime = 2;
    userWorkTime = 1500;
    userBreakTime = 300;
    useLongBreak = YES;
    tickSoundOn = YES;
    }
    return self;
}

- (void) setUserWorkTime: (int) newWorkTime
{
    userWorkTime = newWorkTime * 60;
}

- (void) setUserBreakTime: (int) newBreakTime
{
    userBreakTime = newBreakTime * 60;
}




@end
