//
//  TestTaslDetailController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskDetailsController.h"
#import "TaskDetailNameCel.h"
#import "TaskDetailContentCell.h"
#import "TaskDetailTagCell.h"


#import "User.h"
#import "PhtotoController.h"
#import "EditTaskNameController.h"
#import "SetTagController.h"
#import "AddSubTaskController.h"
#import "SubTaskCell.h"
#import "AddTaskController.h"
#import "BaseNavgationController.h"

@interface TaskDetailsController ()<UITableViewDataSource , UITableViewDelegate>
{
    SetTagController *setTaskTagCtl ;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic ,retain)EditTaskNameController *editTaskNameCtl ;

@end

@implementation TaskDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BaseNavgationController *AddTaskNavCtl =  [self fetchViewControllerByIdentifier:@"AddTaskNavCtl"];
    AddTaskController *addTaskCtl = (AddTaskController*)AddTaskNavCtl.topViewController;
    addTaskCtl.taskModel = self.taskModel ;
    [self presentViewController:AddTaskNavCtl animated:YES completion:nil];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    WS(weakSelf );
    
    if ([segue.identifier isEqualToString:@"SetTagControllerSegue"]){
       setTaskTagCtl = segue.destinationViewController ;
        setTaskTagCtl.curTaskTagType = [self.taskModel.taskTag intValue] ;
        setTaskTagCtl.selectedTaskTagBlock = ^(NSInteger taskTag){
            weakSelf.taskModel.taskTag = [NSNumber numberWithInteger:taskTag];
            [[CoreDataStack shareManaged].managedObjectContext save:nil];
             [weakSelf.tableView reloadData];
        };

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
            TaskDetailNameCel*cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailNameCell" forIndexPath:indexPath];
            [cell configureCellWithTableView:tableView indexPath:indexPath taskModel:self.taskModel];
            return cell ;
        }
        if (indexPath.row < self.taskModel.subTasks.count + 1) {
            SubTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTaskCell" forIndexPath:indexPath];
            [cell configureCellWithTableView:tableView indexPath:indexPath taskModel:self.taskModel];
            return cell ;
        }
    }
    
    //普通
    if (indexPath.section == 2) {
        TaskDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailTagCell" forIndexPath:indexPath];
        [cell configureCellWithTable:tableView indexPath:indexPath taskModel:self.taskModel];
        return cell ;
    }
    
    TaskDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailContentCell" forIndexPath:indexPath];
    [cell configureCellWithTable:tableView indexPath:indexPath taskModel:self.taskModel];
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
    
    
    
}

@end
