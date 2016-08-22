//
//  TimeIsMoneySettingsViewController.h
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TimeIsMoneySettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *workTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *breakTimeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *tickSoundOnSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useLongBreakSwitch;
@property (weak, nonatomic) AppDelegate *delegate;

-(IBAction)Countdown: (id) sender;

-(void) updateWorkTimeSettings;
-(void) updateBreakTimeSettings;
-(void) updateTickSoundOnSettings;
-(void) updateUseLongBreakSettings;


@end
