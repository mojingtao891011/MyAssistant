//
//  FollowersController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/16.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "FollowersController.h"
#import "FollowersCell.h"

@interface FollowersController ()<UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FollowersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _followers.count ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowersCell" forIndexPath:indexPath];
    [cell configureCellWithIndexPath:indexPath userModel:_followers[indexPath.row]];
    return cell ;
}
@end
