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
//    self.workTimeLabel.text = [NSString stringWithFormat:@"%d", self.delegate.settings.userWorkTime/60];
    self.workTimeLabel.text = [NSString stringWithFormat:@"%d", 25];
    self.breakTimeLabel.text = [NSString stringWithFormat:@"%d", [AppDelegate getAppDelegate].settings.userBreakTime/60];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self updateWorkTimeSettings];
    [super viewWillDisappear:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
}
-(void) updateUseLongBreakSettings
{
    
}


@end
