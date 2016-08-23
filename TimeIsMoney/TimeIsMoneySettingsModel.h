//
//  TimeIsMoneySettingsModel.h
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeIsMoneySettingsModel : NSObject

@property (nonatomic) int userWorkTime;
@property (nonatomic) int userBreakTime;
@property (nonatomic) BOOL useLongBreak;
@property (nonatomic) BOOL tickSoundOn;

- (void) setUserWorkTime: (int) newWorkTime;
- (void) setUserBreakTime: (int) newBreakTime;
- (void) setUseLongBreak:(BOOL)useLongBreak;
- (void) setTickSoundOn:(BOOL)tickSoundOn;


@end
