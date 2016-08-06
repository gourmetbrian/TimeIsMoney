//
//  ViewController.m
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import "TimeIsMoneyMasterViewController.h"

@interface TimeIsMoneyMasterViewController ()

@end

@implementation TimeIsMoneyMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO change this to grab time from settings
    self.timeLabel.text = @"25:00";
    isCountdownTimerPaused = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doCountdown: (id)sender
{
    if (isCountdownTimerPaused) {
        [self resumeCountdownTimer];
    } else {
        [self startCountdownTimer];
    }
}

-(IBAction)resetCountdown:(id)sender
{
    [self resetCountdownTimer];
}

-(IBAction)pauseCountdown:(id)sender
{
    [self pauseCountdownTimer];
}

-(void)handleTimerTick
{
    remainingTicks--;
    [self updateLabel];
    
    if (remainingTicks <= 0) {
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
}

- (void) startCountdownTimer
{
    if (countdownTimer)
        return;
    
    
    remainingTicks = 1500;
    [self updateLabel];
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
}

- (void) resetCountdownTimer
{
    [countdownTimer invalidate];
    countdownTimer = nil;
    self.timeLabel.text = @"25:00";
    isCountdownTimerPaused = NO;
}

- (void) pauseCountdownTimer
{
    pauseTime = remainingTicks;
    isCountdownTimerPaused = YES;
    [countdownTimer invalidate];
    countdownTimer = nil;
}

-(void) resumeCountdownTimer
{
    isCountdownTimerPaused = NO;
    if (countdownTimer)
        return;
    
    
    remainingTicks = pauseTime;
    [self updateLabel];
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
}

-(void)updateLabel
{
    int seconds = remainingTicks % 60;
    int minutes = (remainingTicks / 60) % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
}





@end
