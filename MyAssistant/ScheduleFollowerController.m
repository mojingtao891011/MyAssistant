//
//  ScheduleFollowerController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleFollowerController.h"
#import "User.h"

@interface ScheduleFollowerController ()

@end

@implementation ScheduleFollowerController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark - UITableViewDate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _followers.count ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];
    User *user = _followers[indexPath.row];
    cell.textLabel.text = user.userName;
    
    return cell ;
}
@end
