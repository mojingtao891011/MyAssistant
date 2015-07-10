//
//  TestScheduleDetailController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleDetailController.h"
#import "ScheduleDetailNameCell.h"
#import "ScheduleSubRemindCell.h"
#import "ScheduleContentCell.h"
#import "AddScheduleController.h"
#import "BaseNavgationController.h"
#import "ScheduleFollowerController.h"
#import "PhtotoController.h"

@interface ScheduleDetailController ()<UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation ScheduleDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initBarButtonItem];
}
#pragma mark - UI
- (void)_initBarButtonItem
{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItemRight = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barButtonItemRight ;
    
}
#pragma mark - Action
- (void)rightBarButtonItemAction:(UIButton*)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavgationController *addScheduleNavCtl = [storyboard instantiateViewControllerWithIdentifier:@"AddScheduleNavCtl"];
    AddScheduleController* scheduleCtl = (AddScheduleController*)addScheduleNavCtl.topViewController;
    scheduleCtl.scheduleModel = self.scheduleModel ;
    [self presentViewController:addScheduleNavCtl animated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = @[@(1) , @(1) , @(_scheduleModel.subReminds.count) , @(1)];
    return [arr[section] integerValue];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ScheduleDetailNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleDetailNameCell" forIndexPath:indexPath];
        [cell configureCellWithIndexPath:indexPath scheduleModel:self.scheduleModel];
        return cell ;
    }
    else if (indexPath.section == 2){
        ScheduleSubRemindCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleSubRemindCell" forIndexPath:indexPath];
        [cell configureCellWithIndexPath:indexPath scheduleModel:self.scheduleModel];
        return cell ;
    }
    
    ScheduleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleContentCell" forIndexPath:indexPath];
    [cell configureCellWithIndexPath:indexPath scheduleModel:self.scheduleModel];
    return cell ;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100.0;
    }
    return 44.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //参与者
    if (indexPath.section == 1) {
        ScheduleFollowerController *scheduleFollowerCtl = [self fetchViewControllerByIdentifier:@"ScheduleFollowerController"];
        scheduleFollowerCtl.followers = [self.scheduleModel.scheduleFollowers allObjects];
        [self.navigationController pushViewController:scheduleFollowerCtl animated:YES];
    }
    //附件
    else if (indexPath.section == 3){
        PhtotoController *photoCtl = [[PhtotoController alloc]init];
        photoCtl.scheduleModel = self.scheduleModel ;
        photoCtl.isHideRight = YES ;
        [self.navigationController pushViewController:photoCtl animated:YES];
    }
}
@end
