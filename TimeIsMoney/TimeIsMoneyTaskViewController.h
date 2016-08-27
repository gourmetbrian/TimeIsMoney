//
//  TimeIsMoneyTaskViewController.h
//  TimeIsMoney
//
//  Created by Brian Lane on 8/23/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TimeIsMoneyTaskViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *greekLetters;
@property (copy, nonatomic) NSMutableArray *completedTomatoes;
@property (weak, nonatomic) AppDelegate *delegate;





@end
