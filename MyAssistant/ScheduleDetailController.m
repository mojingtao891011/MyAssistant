//
//  TestScheduleDetailController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleDetailController.h"
#import "ScheduleDetailNameCell.h"
#import "ScheduleContentCell.h"
#import "AddScheduleController.h"
#import "BaseNavgationController.h"
#import "ScheduleFollowerController.h"
#import "PhtotoController.h"
#import "ScheduleSubRemindCell.h"

@interface ScheduleDetailController ()<UITableViewDataSource , UITableViewDelegate , UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation ScheduleDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initBarButtonItem];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modificationComplection:)name:NOTE_MODIFICATION_SCHEDULE object:nil];
}
#pragma mark - UI
- (void)_initBarButtonItem
{
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setFrame:CGRectMake(0, 0, 40, 30)];
    [editButton setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    editButton.backgroundColor = [UIColor clearColor];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(0, 0, 40, 30)];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc]initWithCustomView:deleteButton];
    self.navigationItem.rightBarButtonItems = @[ deleteBarButton,editBarButton];
}
#pragma mark - Action

- (void)editButtonItemAction:(UIButton*)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavgationController *addScheduleNavCtl = [storyboard instantiateViewControllerWithIdentifier:@"AddScheduleNavCtl"];
    AddScheduleController* scheduleCtl = (AddScheduleController*)addScheduleNavCtl.topViewController;
    scheduleCtl.scheduleModel = self.scheduleModel ;
    
    [self presentViewController:addScheduleNavCtl animated:YES completion:nil];
}
- (void)deleteButtonItemAction:(UIButton*)sender
{
    [[[UIAlertView alloc]initWithTitle:@"您确定要删除" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show ];
    
}
- (void)modificationComplection:(NSNotification*)note
{
    self.scheduleModel = note.object ;
    [self.tableView reloadData];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSDate *scheduleStartTime = self.scheduleModel.schedulestartTime ;
        if ([CoreDataModelService deleteScheduleByScheduleModel:self.scheduleModel]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_DELETEMODEL object:scheduleStartTime];
            });
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
        };
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    NSArray *arr = @[@(1) , @(1) , @(_scheduleModel.reminds.count) , @(1)];
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
