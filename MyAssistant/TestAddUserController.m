//
//  TestAddUserController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/7.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TestAddUserController.h"

@interface TestAddUserController ()

@end

@implementation TestAddUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)leftAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectedUserAction:(UIButton *)sender {
    
    sender.selected = !sender.selected ;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil ;
    }
    UIView *headerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
     headerView.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 22)];
    label.textColor = LIGHTGREY_FONT_COLOR ;
    label.font = [UIFont systemFontOfSize:12.0];
    label.backgroundColor = [UIColor clearColor];
    NSArray *arr = @[@"常用联系人",@"A"];
    label.text = arr[section - 1];
    [headerView addSubview:label];
    return headerView ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
