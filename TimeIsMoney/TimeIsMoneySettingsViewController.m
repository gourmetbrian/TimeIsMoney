//
//  TimeIsMoneySettingsViewController.m
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import "TimeIsMoneySettingsViewController.h"

@interface TimeIsMoneySettingsViewController ()

@end

@implementation TimeIsMoneySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSettingsAndUpdateView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self getSettingsAndUpdateView];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self updateAllSettings];
    [super viewWillDisappear:YES];
}

#pragma mark - getSettingsAndUpdateView

-(void) getSettingsAndUpdateView
{
    //      Commented out for debugging
    self.workTimeLabel.text = [NSString stringWithFormat:@"%d", [AppDelegate getAppDelegate].settings.userWorkTime/60];
    self.breakTimeLabel.text = [NSString stringWithFormat:@"%d", [AppDelegate getAppDelegate].settings.userBreakTime/60];
//    self.workTimeLabel.text = [NSString stringWithFormat:@"%d", [AppDelegate getAppDelegate].settings.userWorkTime];
//    self.breakTimeLabel.text = [NSString stringWithFormat:@"%d", [AppDelegate getAppDelegate].settings.userBreakTime];
    if ([AppDelegate getAppDelegate].settings.tickSoundOn == YES){
        [self.tickSoundOnSwitch setOn:YES];
    } else {
        [self.tickSoundOnSwitch setOn:NO];

    }
    if ([AppDelegate getAppDelegate].settings.useLongBreak == YES){
        [self.useLongBreakSwitch setOn:YES];
    } else {
        [self.useLongBreakSwitch setOn:NO];
        
    }
}

#pragma mark - updateSettings

-(void) updateWorkTimeSettings
{
    [[AppDelegate getAppDelegate].settings setUserWorkTime:[self.workTimeLabel.text intValue]];
}

-(void) updateBreakTimeSettings
{
    [[AppDelegate getAppDelegate].settings setUserBreakTime:[self.breakTimeLabel.text intValue]];
}

-(void) updateTickSoundOnSettings
{
    if ([self.tickSoundOnSwitch isOn]){
        [AppDelegate getAppDelegate].settings.tickSoundOn = 1;
    } else {
//        [[AppDelegate getAppDelegate].settings toggleTickSoundOn];
        [AppDelegate getAppDelegate].settings.tickSoundOn = 0;
    };

}

-(void) updateUseLongBreakSettings
{
    if ([self.useLongBreakSwitch isOn]){
        [AppDelegate getAppDelegate].settings.useLongBreak = 1;
    } else {
        [AppDelegate getAppDelegate].settings.useLongBreak = 0;
    };
}

-(void) updateAllSettings
{
    [self updateWorkTimeSettings];
    [self updateBreakTimeSettings];
    [self updateTickSoundOnSettings];
    [self updateUseLongBreakSettings];
}

@end
