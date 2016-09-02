//
//  ViewController.m
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TimeIsMoneyMasterViewController.h"
#import "AppDelegate.h"
#import "OALSimpleAudio.h"



@interface TimeIsMoneyMasterViewController ()

@property (nonatomic) int remainingTicks;
@property (nonatomic) int pauseTime;
@property (nonatomic) int consecutiveSessionsCount;

@property (nonatomic, strong) UIColor* pauseBackgroundColor;

@property (nonatomic) TimerState previousState;
@property (nonatomic) TimerState timerState;
@property (nonatomic) NSTimer *countdownTimer;

@end

@implementation TimeIsMoneyMasterViewController
{


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pauseBackgroundColor = [UIColor colorWithRed:152/255.0 green:199/255.0 blue:255/255.0 alpha:1.0];
    [self setTimerState:STOPPED];
    self.remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    [self updateLabel];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"tick.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"alarm.mp3"];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_timerState != RUNNING_TASK && _timerState != RUNNING_BREAK) {
    _remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    }
    [self updateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init method

-(instancetype) init
{
    self = [super init];
    if (self)   {
        self.timerState = STOPPED;
        self.previousState = self.timerState;
        self.remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    }
    return self;
}


#pragma mark - button actions
-(IBAction)doCountdown: (id)sender
{
    if (self.countdownTimer)
    return;
    if (self.timerState == PAUSED) {
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
    if (!self.countdownTimer)
        return;
    [self pauseCountdownTimer];
}


#pragma mark Timer methods

-(void)handleTimerTick
{
    _remainingTicks--;
    [self updateLabel];
    
    if (_remainingTicks <= 0) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;
        if (_timerState == RUNNING_TASK) {
            [[OALSimpleAudio sharedInstance] playEffect:@"alarm.mp3"];
            [self transitionToBreak];
        } else if (_timerState == RUNNING_BREAK) {
            [self transitionFromBreak];
        };
    }
}

- (void) startCountdownTimer
{
    
    if (self.countdownTimer)
        return;
    switch (self.timerState)
    {
        case RUNNING_TASK:
            [self setTimerState:RUNNING_BREAK];
            break;
        case STOPPED:
        case PAUSED:
            self.view.backgroundColor = [UIColor redColor];
            [self.timeLabel setText:@"Break!"];
            [self setTimerState:RUNNING_TASK];
            break;
        case RUNNING_BREAK:
            break;
    }
    [self updateLabel];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
}

- (void) resetCountdownTimer
{
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    self.remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    [self updateLabel];
    [self setTimerState:STOPPED];
    self.view.backgroundColor = self.pauseBackgroundColor;
}

- (void) pauseCountdownTimer
{
    self.pauseTime = self.remainingTicks;
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    [self setTimerState:PAUSED];
}

-(void) resumeCountdownTimer
{
    self.remainingTicks = self.pauseTime;
    [self startCountdownTimer];
}

-(void)updateLabel
{
    
    int seconds = self.remainingTicks % 60;
    int minutes = (self.remainingTicks / 60);
    if (minutes > 99) {
        self.timeLabel.text = [NSString stringWithFormat:@"%3d:%02d", minutes, seconds];
 
    } else if (minutes >= 10) {
        [self.timeLabel setText:([NSString stringWithFormat:@"%2d:%02d", minutes, seconds])];
    } else {
       [self.timeLabel setText:([NSString stringWithFormat:@"0%1d:%02d", minutes, seconds])];
    }
    if ([AppDelegate getAppDelegate].settings.tickSoundOn == YES && self.timerState == RUNNING_TASK)
    {
        [[OALSimpleAudio sharedInstance] playEffect:@"tick.mp3"];
    }
    
}

#pragma mark - State functions
-(void) setTimerState:(TimerState) newState
{
   if (_timerState) _previousState = _timerState;
    _timerState = newState;
}

-(void) promptUserForTaskEntry
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"You finished"
                                  message:@"Enter Your Completed Work"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSString *timeStamp = [self generateTimeStamp];
                             [AppDelegate getAppDelegate].task = [NSString stringWithFormat:@"%@: %@", timeStamp, alert.textFields.firstObject.text];
                             [[AppDelegate getAppDelegate].completedTomatoes insertObject:[AppDelegate getAppDelegate].task atIndex:0];

                             [[AppDelegate getAppDelegate] saveSettings:[AppDelegate getAppDelegate].completedTomatoes];

                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self startCountdownTimer];
                              
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self startCountdownTimer];
                                 
                             }];
    
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"What did you work on?"; 
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) transitionToBreak
{
    if ([AppDelegate getAppDelegate].settings.useLongBreak)
    /* Using long break, we count the number of consecutive sessions */
    {
        if (self.consecutiveSessionsCount <2) {
            self.remainingTicks = [AppDelegate getAppDelegate].settings.userBreakTime;
            self.consecutiveSessionsCount++;
        } else {
            self.remainingTicks = 600;
           self.consecutiveSessionsCount = 0;
        }
    } else {
        /*not using long break, reset consecutive sessions count and proceed w/ user determined break*/
        self.remainingTicks = [AppDelegate getAppDelegate].settings.userBreakTime;
        self.consecutiveSessionsCount = 0;
    }
    [self.timeLabel setText:@"Break!"];
    [self promptUserForTaskEntry];
    [self setTimerState:RUNNING_BREAK];
    self.view.backgroundColor = self.pauseBackgroundColor;
}

-(void) transitionFromBreak
{
    self.remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    [self updateLabel];
    [self setTimerState:STOPPED];
    self.view.backgroundColor = self.pauseBackgroundColor;

}

-(NSString *) generateTimeStamp
{
    NSDate *now = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY HH:mm"];

    NSString *timeStamp = [formatter stringFromDate:now];
    return timeStamp;
}

@end
