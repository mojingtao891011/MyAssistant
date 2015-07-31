//
//  TestTaslDetailController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskDetailsController.h"
#import "TaskDetailNameCell.h"
#import "TaskDetailContentCell.h"
#import "TaskDetailTagCell.h"
#import "User.h"
#import "PhtotoController.h"
#import "SetTagController.h"
#import "AddSubTaskController.h"
#import "SubTaskCell.h"
#import "AddTaskController.h"
#import "BaseNavgationController.h"
#import "FollowersController.h"


@interface TaskDetailsController ()<UITableViewDataSource , UITableViewDelegate , TaskDetailNameCellDelegate , SubTaskCellDelegate , UIAlertViewDelegate>
{
    SetTagController *setTaskTagCtl ;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaskDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initBarButtonItem];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modificationComplection:) name:NOTE_MODIFICATION_TASK object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BaseNavgationController *AddTaskNavCtl =  [self fetchViewControllerByIdentifier:@"AddTaskNavCtl"];
    AddTaskController *addTaskCtl = (AddTaskController*)AddTaskNavCtl.topViewController;
    addTaskCtl.taskModel = self.taskModel ;
    [self presentViewController:AddTaskNavCtl animated:YES completion:nil];
    
}
- (void)deleteButtonItemAction:(UIButton*)sender
{
    [[[UIAlertView alloc]initWithTitle:@"您确定要删除" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show ];
    
    
}
- (void)modificationComplection:(NSNotification*)note
{
    self.taskModel = note.object ;
    [self.tableView reloadData];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSDate *taskStartTime = self.taskModel.taskStartTime ;
        if ([CoreDataModelService deleteTaskByTaskModel:self.taskModel]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_DELETEMODEL object:taskStartTime];
            });
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
        };
    }
    
}
#pragma mark - CellDelegate
- (void)setTaskState:(BOOL)isFinish
{
    self.taskModel.taskIsFininsh = [NSNumber numberWithBool:isFinish];
    
    if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
        debugLog(@"isfininsh error");
    }
    
}
- (void)setSubTaskState:(BOOL)isFininsh index:(NSInteger)index
{
    SubTask *subTask = [self.taskModel.subTasks allObjects][index];
    subTask.isFininsh = [NSNumber numberWithBool:isFininsh] ;
    if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
        debugLog(@"isfininsh error");
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arr = @[@(self.taskModel.subTasks.count+3) , @(1) , @(1) , @(1) , @(2)];
    
    return [arr[section] integerValue];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //主任务、子任务
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            TaskDetailNameCell*cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailNameCell" forIndexPath:indexPath];
            cell.delegate = self ;
            [cell configureCellWithTableView:tableView indexPath:indexPath taskModel:self.taskModel];
            return cell ;
        }
        else if (indexPath.row < self.taskModel.subTasks.count + 1) {
            SubTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTaskCell" forIndexPath:indexPath];
            cell.delegate = self ;
            cell.selectButton.tag = indexPath.row - 1 ;
            NSArray *arr = [self.taskModel.subTasks allObjects];
            [cell configureCellWithTableView:tableView indexPath:indexPath subTaskModel:arr[indexPath.row - 1]];
            return cell ;
        }
        
    }
    
    //普通
    if (indexPath.section == 2) {
        TaskDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailTagCell" forIndexPath:indexPath];
        [cell configureCellWithTable:tableView indexPath:indexPath taskModel:self.taskModel];
        return cell ;
    }
    
    
    //other cell
    TaskDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailContentCell" forIndexPath:indexPath];
    [cell configureCellWithTable:tableView indexPath:indexPath taskModel:self.taskModel];
    
    //有更多箭头
    if (indexPath.section == 1 || indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    
    return cell ;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row < self.taskModel.subTasks.count + 1) {
        return 70.0;
    }
    
    return 44.0 ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        FollowersController *followersCtl = [self fetchViewControllerByIdentifier:@"FollowersController"];
        followersCtl.followers = [self.taskModel.followers allObjects];
        [self.navigationController pushViewController:followersCtl animated:YES];
    }
    else if (indexPath.section == 3){
        PhtotoController *photoCtl = [[PhtotoController alloc]init];
        photoCtl.isHideRight = YES ;
        photoCtl.taskModel = self.taskModel ;
        [self.navigationController pushViewController:photoCtl animated:YES];
    }
}

@end
