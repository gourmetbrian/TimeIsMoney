//
//  ViewController.h
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum timerState
{
    STOPPED,
    PAUSED,
    RUNNING_TASK,
    RUNNING_BREAK,
} TimerState;

@interface TimeIsMoneyMasterViewController : UIViewController
{
    TimerState previousState;
    TimerState timerState;
    @private
    NSTimer *countdownTimer;
    int remainingTicks;
    int pauseTime;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

-(IBAction)doCountdown: (id) sender;

- (void) startCountdownTimer;
- (void) resetCountdownTimer;
- (void) pauseCountdownTimer;


-(void)handleTimerTick;

-(void)updateLabel;

-(void) setTimerState:(TimerState) newState;
-(void) promptUserForTaskEntry;
-(void) transitionToBreak;


@end

