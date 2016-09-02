//
//  TimeIsMoneyTaskViewController.m
//  TimeIsMoney
//
//  Created by Brian Lane on 8/23/16.
//  Copyright © 2016 Brian Lane. All rights reserved.
//

#import "TimeIsMoneyTaskViewController.h"

@interface TimeIsMoneyTaskViewController ()

@end

@implementation TimeIsMoneyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AppDelegate getAppDelegate].completedTomatoes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleIdentifier = @"SimpleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:simpleIdentifier];
    }

    cell.textLabel.text = [AppDelegate getAppDelegate].completedTomatoes[indexPath.row];
    return cell;
}


@end
