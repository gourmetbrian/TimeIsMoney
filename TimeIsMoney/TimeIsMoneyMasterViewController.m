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
    isCountdownTimerPaused = NO;
    
    _delegate = [UIApplication sharedApplication].delegate;
    _delegate.settings = [[TimeIsMoneySettingsModel alloc] init];
    NSLog(@"MainViewController viewDidLoad: %i", _delegate.settings.userWorkTime);
    remainingTicks = _delegate.settings.userWorkTime;
    [self updateLabel];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    remainingTicks = _delegate.settings.userWorkTime;
    [self updateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button actions
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


#pragma mark Timer methods

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
    
    
//    remainingTicks = 1500;
    [self updateLabel];
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
}

- (void) resetCountdownTimer
{
    [countdownTimer invalidate];
    countdownTimer = nil;
    remainingTicks = _delegate.settings.userWorkTime;
    [self updateLabel];
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
    remainingTicks = pauseTime;
    [self startCountdownTimer];
//    if (countdownTimer)
//        return;
//    
//    
//    remainingTicks = pauseTime;
//    [self updateLabel];
//    
//    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
//                                                      target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
}

-(void)updateLabel
{
    int seconds = remainingTicks % 60;
    int minutes = (remainingTicks / 60);
    if (minutes > 99) {
        self.timeLabel.text = [NSString stringWithFormat:@"%3d:%02d", minutes, seconds];
 
    } else if (minutes >= 10) {
    self.timeLabel.text = [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"0%1d:%02d", minutes, seconds];

    }
}





@end
