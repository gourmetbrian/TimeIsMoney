//
//  ViewController.h
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TimeIsMoneySettingsModel.h"

@interface TimeIsMoneyMasterViewController : UIViewController
{
    @private
    NSTimer *countdownTimer;
    int remainingTicks;
    int pauseTime;
    BOOL isCountdownTimerPaused;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) TimeIsMoneySettingsModel *settings;

-(IBAction)doCountdown: (id) sender;

- (void) startCountdownTimer;
- (void) resetCountdownTimer;
- (void) pauseCountdownTimer;


-(void)handleTimerTick;

-(void)updateLabel;

@end

