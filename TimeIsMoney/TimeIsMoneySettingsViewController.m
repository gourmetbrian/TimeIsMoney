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
    _delegate = [UIApplication sharedApplication].delegate;
    self.workTimeLabel.text = [NSString stringWithFormat:@"%d", _delegate.settings.userWorkTime/60];
    self.breakTimeLabel.text = [NSString stringWithFormat:@"%d", _delegate.settings.userBreakTime/60];
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
    [_delegate.settings setUserWorkTime:[self.workTimeLabel.text intValue]];
}

-(void) updateBreakTimeSettings
{
    [_delegate.settings setUserBreakTime:[self.breakTimeLabel.text intValue]];
}

-(void) updateTickSoundOnSettings
{
    
}
-(void) updateUseLongBreakSettings
{
    
}


@end
