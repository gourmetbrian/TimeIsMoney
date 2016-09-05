//
//  TimeIsMoneyConstants.m
//  TimeIsMoney
//
//  Created by Brian Lane on 9/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import "TimeIsMoneyConstants.h"

@implementation TimeIsMoneyConstants

NSString *const SavedUserTasksKey = @"SavedUserTasks";
const int WORK_TIME = 1500;
const int BREAK_TIME = 300;


+(UIColor*) getPauseBackgroundColor
{
    return [UIColor colorWithRed:152/255.0 green:199/255.0 blue:255/255.0 alpha:1.0];
}

@end
