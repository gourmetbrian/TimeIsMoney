//
//  ViewController.m
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import "TimeIsMoneyMasterViewController.h"
#import "AppDelegate.h"

@interface TimeIsMoneyMasterViewController ()

@end

@implementation TimeIsMoneyMasterViewController
{
    TimerState previousState;
    TimerState timerState;
@private
    NSTimer *countdownTimer;
    int remainingTicks;
    int pauseTime;
    UIColor *pauseBackgroundColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    timerState = STOPPED;
    previousState = STOPPED;
    pauseBackgroundColor = [UIColor colorWithRed:152/255.0 green:199/255.0 blue:255/255.0 alpha:1.0];
    remainingTicks = [AppDelegate getAppDelegate].settings.userWorkTime;
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
    NSLog(@"Test");
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
    
}

-(void) setTimerState:(TimerState) newState
{
    previousState = timerState;
    timerState = newState;
    NSLog(@"current state is %u and previous state is %u", timerState, previousState);
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
                             for (NSString *yourVar in [AppDelegate getAppDelegate].completedTomatoes) {
                                 
                                 NSLog (@"Your Array elements are = %@", yourVar);
                                 
                             }
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
    remainingTicks = [AppDelegate getAppDelegate].settings.userBreakTime;
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
