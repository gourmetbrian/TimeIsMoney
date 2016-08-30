//
//  AppDelegate.h
//  TimeIsMoney
//
//  Created by Brian Lane on 8/5/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeIsMoneySettingsModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TimeIsMoneySettingsModel* settings;
@property (nonatomic) NSMutableArray *completedTomatoes;
@property (nonatomic) NSString *task;
@property NSUserDefaults *localDefaults;
@property NSString* savedUserTasks;

+(AppDelegate *) getAppDelegate;

-(void)saveSettings:(NSMutableArray*) completedTasks;
-(NSMutableArray*)getSettings;

@end

