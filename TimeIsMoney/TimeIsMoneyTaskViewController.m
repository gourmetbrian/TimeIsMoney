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
    self.delegate = [UIApplication sharedApplication].delegate;
    self.greekLetters = @[@"poop", @"pee", @"fart", @"butts", @"tities", @"smellbutts", @"bigcrayp", @"stinks", @"stenchburger", @"ediblepoop", @"woof", @"diarrhea", @"a", @"b", @"c", @"3", @"V", @"H", @"t", @"re", @"pool"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate.completedTomatoes count];
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
                
    cell.textLabel.text = self.delegate.completedTomatoes[indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
*/

@end
