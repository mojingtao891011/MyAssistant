//
//  AddFriendsController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/27.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddFriendsController.h"
#import "AddFriendsOneCell.h"
#import "AddFriendsTwoCell.h"
#import "User.h"

@interface AddFriendsController ()<UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , retain)NSArray *friends ;

@end

@implementation AddFriendsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.friends = [[CoreDataModelService fetchUserByName:USER_ID].friends allObjects];
    
    if (_isAddFriend) {
        [self _initLeftBar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
- (void)_initLeftBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 50, 44)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    backButton.imageEdgeInsets = edgeInsets;
    [backButton addTarget:self action:@selector(myBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBrttonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barBrttonItem ;
}
#pragma mark - Action
- (void)myBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 ;
    }
    return self.friends.count ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AddFriendsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsOneCell" forIndexPath:indexPath];
        return cell ;
    }
    
    AddFriendsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsTwoCell" forIndexPath:indexPath];
    cell.inviteButton.tag = indexPath.row ;
    cell.friends = self.friends ;
    return cell ;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120.0;
    }
    
    return 50.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil ;
    }
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableCellWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 40, 20)];
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.font = [UIFont systemFontOfSize:10.0];
        headerLabel.tag = 1 ;
        [headerView addSubview:headerLabel];
    }
    UILabel *label = (UILabel*)[headerView viewWithTag:1];
    label.text = @"好友推荐";
    return headerView ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0 ;
    }
    
    return 22.0 ;
}
@end
