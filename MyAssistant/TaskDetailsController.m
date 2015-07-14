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
#import "DatePickerViewController.h"

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
    
    
//    switch (indexPath.section) {
//        case 0:
//            [self didSelectedFirstSection:indexPath];
//            break;
//        case 1:
//            [self didSelectedSecondSection:indexPath];
//            break;
//        case 2:
//            [self didSelectedThreeSection:indexPath];
//            break;
//        case 3:
//            [self didSelectedFourSection:indexPath];
//            break;
//        
//            break;
//        default:
//            break;
//    }
    
}
#pragma mark - selectedSection
#pragma mark - 标题、子任务、设置时间、执行者
- (void)didSelectedFirstSection:(NSIndexPath*)indexPath
{
    WS(weakSelf);
    //标题
    if (indexPath.row == 0) {
        EditTaskNameController *editTaskNameCtl  = [self fetchViewControllerByIdentifier:@"EditTaskNameController"] ;
        editTaskNameCtl.myTask = self.taskModel ;
        editTaskNameCtl.EditTaskCompleteBlock = ^(Task *task){
            
            weakSelf.taskModel = task ;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:editTaskNameCtl animated:YES];
    }
    //设置时间
    else if (indexPath.row == self.taskModel.subTasks.count +1) {
        DatePickerViewController *dataPickerCtl = [self fetchViewControllerByIdentifier:@"DatePickerController"];
        dataPickerCtl.startTime = self.taskModel.taskStartTime ;
        dataPickerCtl.endTime = self.taskModel.taskEndTime;
        dataPickerCtl.scheuleDateBlock = ^(NSDate *startTime , NSDate *endTime){
            
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //判断是否是今年 、今天
                NSString *startString = nil ;
                NSString *endString = nil ;
                //开始时间
                if ([startTime isThisYear]) {
                    startString = [Tool stringFromFomate:startTime formate:@"MM月dd日"];
                }
                else{
                    startString = [Tool stringFromFomate:startTime formate:@"yyyy年MM月dd日"] ;
                }
                
                if ([startTime isToday]) {
                    startString = @"今天";
                }
                //结束时间
                if ([endTime isThisYear]) {
                    endString = [Tool stringFromFomate:endTime formate:@"MM月dd日"] ;
                }
                else{
                    endString = [Tool stringFromFomate:endTime formate:@"yyyy年MM月dd日"] ;
                }
                
                //开始时间、结束时间都是今天(今天00:15-0630)
                if ([startTime isToday] &&[endTime isToday] ) {
                    startString  = [NSString stringWithFormat:@"今天%@",[Tool stringFromFomate:startTime formate:@"HH:mm"]];
                    endString = [Tool stringFromFomate:endTime formate:@"HH:mm"] ;
                }
                
                TaskDetailContentCell *cell = (TaskDetailContentCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
                cell.cellTextLabel.text = [NSString stringWithFormat:@"%@-%@" , startString , endString];
                cell.cellEndTextLabel.text = @"";

            });
            
            //保存时间
            weakSelf.taskModel.taskStartTime = startTime ;
            weakSelf.taskModel.taskEndTime = endTime ;
            
        };
         [self.navigationController pushViewController:dataPickerCtl animated:YES];
    }
    //执行者
    else if (indexPath.row == self.taskModel.subTasks.count +2){
        /*
        ExecutorController *executor = [self fetchViewControllerByIdentifier:@"ExecutorController"];
        executor.executorUser = self.taskModel.executor ;
        
        executor.selectExecutorBlock = ^(User *user){
            //
            self.taskModel.executor = user ;
            
             TaskDetailContentCell *cell = (TaskDetailContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellEndTextLabel.text = user.userName ;
            
        };
        [self.navigationController pushViewController:executor animated:YES];
        */
    }
    //子任务
    else {
        AddSubTaskController *addSubTaskCtl = [self fetchViewControllerByIdentifier:@"AddSubTaskController"];
        addSubTaskCtl.subTask = [self.taskModel.subTasks allObjects][indexPath.row - 1];
        addSubTaskCtl.saveSubTaskBlock = ^(SubTask *subTask){
            
            NSMutableSet *mutableSet = (NSMutableSet*)weakSelf.taskModel.subTasks ;
            [mutableSet removeObject:[weakSelf.taskModel.subTasks allObjects][indexPath.row - 1]];
            [mutableSet addObject:subTask];
            [weakSelf.taskModel addSubTasks:mutableSet];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            });

        };
        [self.navigationController pushViewController:addSubTaskCtl animated:YES];
    }
}
#pragma mark - 参与者
- (void)didSelectedSecondSection:(NSIndexPath*)indexPath
{
    /*
    ExecutorController *executor = [self fetchViewControllerByIdentifier:@"ExecutorController"];
    
    executor.follows = [NSMutableArray arrayWithArray:[self.taskModel.followers allObjects]];
    
    executor.selectFollowersBlock = ^(NSMutableArray *followers){
        
        //参与者
        NSSet *set = [NSSet setWithArray:followers];
        self.taskModel.followers = set ;
        
        NSMutableString *appNameStr = [NSMutableString new];
        for (User *user in followers) {
            [appNameStr appendFormat:@" %@" , user.userName];
        }
        
        TaskDetailContentCell *cell = (TaskDetailContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.cellEndTextLabel.text = appNameStr ;
        
    };
    [self.navigationController pushViewController:executor animated:YES];
     */
}
#pragma mark - 普通
- (void)didSelectedThreeSection:(NSIndexPath*)indexPath
{
    
    TaskDetailTagCell *cell = (TaskDetailTagCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    int taskTag = [self.taskModel.taskTag intValue];
    switch (taskTag) {
        case 0:
             setTaskTagCtl.curTaskTagType = OrdinaryType ;
            cell.stateImageView.backgroundColor = SET_TASK_TAG0 ;
            break;
        case 1:
             setTaskTagCtl.curTaskTagType = UrgentType ;
            cell.stateImageView.backgroundColor = SET_TASK_TAG1 ;
            break;
        case 2:
             setTaskTagCtl.curTaskTagType = ImportantType ;
            cell.stateImageView.backgroundColor = SET_TASK_TAG2 ;
            break;
        case 3:
             setTaskTagCtl.curTaskTagType = VeryUrgentType ;
            cell.stateImageView.backgroundColor = SET_TASK_TAG3 ;
            break;
            
        default:
            break;
    }
    
    //[self.navigationController pushViewController:setTaskTagCtl animated:YES];
}
#pragma mark - 附件
- (void)didSelectedFourSection:(NSIndexPath*)indexPath
{
    PhtotoController *photoCtl = [[PhtotoController alloc]init];
    photoCtl.taskModel = self.taskModel ;
    photoCtl.annexUploadCountBlock = ^(NSInteger annexUploadCount){
        //
        TaskDetailContentCell *cell = (TaskDetailContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.cellEndTextLabel.text = [NSString stringWithFormat:@"%d" , (int)annexUploadCount];
    };
    [self.navigationController pushViewController:photoCtl animated:YES];
    
}
#pragma mark - 评论
@end
