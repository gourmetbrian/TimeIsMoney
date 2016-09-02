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


@interface TimeIsMoneyMasterViewController ()

@end

@implementation TimeIsMoneyMasterViewController
{
    TimerState previousState;
    TimerState timerState;
    NSTimer *countdownTimer;
    int remainingTicks;
    int pauseTime;
    UIColor *pauseBackgroundColor;
    AVAudioPlayer *audioPlayer;
    int consecutiveSessionsCount;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAudioPlayer];
    pauseBackgroundColor = [UIColor colorWithRed:152/255.0 green:199/255.0 blue:255/255.0 alpha:1.0];
    [self updateLabel];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (timerState != RUNNING_TASK && timerState != RUNNING_BREAK) {
    remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
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
        timerState = STOPPED;
        previousState = STOPPED;
        remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    }
    return self;
}


#pragma mark - button actions
-(IBAction)doCountdown: (id)sender
{
    if (countdownTimer)
    return;
    if (timerState == PAUSED) {
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
    if (!countdownTimer)
        return;
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
        if (timerState == RUNNING_TASK) {
            [self transitionToBreak];
        } else if (timerState == RUNNING_BREAK) {
            [self transitionFromBreak];
        };
    }
}

- (void) startCountdownTimer
{
    
    if (countdownTimer)
        return;
    switch (timerState)
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
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
}

- (void) resetCountdownTimer
{
    [countdownTimer invalidate];
    countdownTimer = nil;
    remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    [self updateLabel];
    [self setTimerState:STOPPED];
    self.view.backgroundColor = pauseBackgroundColor;
}

- (void) pauseCountdownTimer
{
    pauseTime = remainingTicks;
    [countdownTimer invalidate];
    countdownTimer = nil;
    [self setTimerState:PAUSED];
}

-(void) resumeCountdownTimer
{
    remainingTicks = pauseTime;
    [self startCountdownTimer];
}

-(void)updateLabel
{
    
    int seconds = remainingTicks % 60;
    int minutes = (remainingTicks / 60);
    if (minutes > 99) {
        self.timeLabel.text = [NSString stringWithFormat:@"%3d:%02d", minutes, seconds];
 
    } else if (minutes >= 10) {
        [self.timeLabel setText:([NSString stringWithFormat:@"%2d:%02d", minutes, seconds])];
    } else {
       [self.timeLabel setText:([NSString stringWithFormat:@"0%1d:%02d", minutes, seconds])];
    }
    if ([AppDelegate getAppDelegate].settings.tickSoundOn == YES && timerState == RUNNING_TASK)
    {
        [audioPlayer play];
    }
    
}

#pragma mark - State functions
-(void) setTimerState:(TimerState) newState
{
    previousState = timerState;
    timerState = newState;
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
        if (consecutiveSessionsCount <2) {
            remainingTicks = [AppDelegate getAppDelegate].settings.userBreakTime;
            consecutiveSessionsCount++;
        } else {
            remainingTicks = 600;
            consecutiveSessionsCount = 0;
        }
    } else {
        /*not using long break, reset consecutive sessions count and proceed w/ user determined break*/
        remainingTicks = [AppDelegate getAppDelegate].settings.userBreakTime;
        consecutiveSessionsCount = 0;
    }
    [self.timeLabel setText:@"Break!"];
    [self promptUserForTaskEntry];
    [self setTimerState:RUNNING_BREAK];
    self.view.backgroundColor = pauseBackgroundColor;
}

-(void) transitionFromBreak
{
    remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
    [self updateLabel];
    [self setTimerState:STOPPED];
    self.view.backgroundColor = pauseBackgroundColor;

}

-(NSString *) generateTimeStamp
{
    NSDate *now = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY HH:mm"];

    NSString *timeStamp = [formatter stringFromDate:now];
    return timeStamp;
}

#pragma mark - Audio Methods

-(void) initAudioPlayer
{
    NSString *path = [NSString stringWithFormat:@"%@/tick.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}




@end
