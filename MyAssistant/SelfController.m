//
//  SelfController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/27.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "SelfController.h"

@interface SelfController ()

@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;

@end

@implementation SelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHidenLeftButton = NO ;
    self.leftButtonImageName = @"icon_self_p";
    
    [self _initDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
- (void)_initDefault
{
    [self.scheduleButton setTitle:@" 12\n日程" forState:UIControlStateNormal];
    self.scheduleButton.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.scheduleButton.titleLabel.font=[UIFont systemFontOfSize:10];
    
    [self.taskButton setTitle:@" 12\n项目" forState:UIControlStateNormal];
    self.taskButton.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.taskButton.titleLabel.font=[UIFont systemFontOfSize:10];
    
    [self.friendButton setTitle:@" 12\n好友" forState:UIControlStateNormal];
    self.friendButton.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.friendButton.titleLabel.font=[UIFont systemFontOfSize:10];
}
#pragma mark - UITabledelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
