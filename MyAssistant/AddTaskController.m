//
//  TestAddTaskController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddTaskController.h"
#import "AddTaskSetTimeCell.h"
#import "AddSubTaskContentCell.h"
#import "DatePickerViewController.h"
#import "PhtotoController.h"
#import "ExecutorController.h"
#import "SetTagController.h"
#import "AddSubTaskController.h"
#import "Task.h"
#import "User.h"
#import "CoreDataStack.h"
#import "CoreDataModelService.h"
#import "Comment.h"
#import "AddSubTaskActionCell.h"
#import "AddSubTaskController.h"

@interface AddTaskController ()<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate>

@property (retain, nonatomic)UITextField *taskNameTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , retain)Task  *taskModel;
@property (nonatomic , retain)NSManagedObjectContext        *context ;

@property (nonatomic , retain)AddSubTaskController *subTaskDetailCtl  ;
@property (nonatomic , retain)SubTask                            *pushToAddSubTaskCtlSubTaskModel;

@end

@implementation AddTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    
    self.context = [CoreDataStack shareManaged].managedObjectContext;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - push-AddSubTaskController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WS(weaSelf);
    
    if ([segue.identifier isEqualToString:@"addTaskCtlPushAddSubTaskCtlSegue"]) {
        AddSubTaskController *addSubTaskCtl = segue.destinationViewController ;
        addSubTaskCtl.saveSubTaskBlock = ^(SubTask *subTask){
            
            
            [weaSelf.taskModel addSubTasks:[NSSet setWithObject:subTask]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[weaSelf.tableView reloadData];
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:4];
                [weaSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
            });
        };
    }
    else if ([segue.identifier isEqualToString:@"subTaskCellPushAddSubTaskCtlSegue"]){
        _subTaskDetailCtl = segue.destinationViewController ;
        
        _subTaskDetailCtl.saveSubTaskBlock = ^(SubTask *subTask){
            
            NSMutableSet *mutableSet = (NSMutableSet*)weaSelf.taskModel.subTasks ;
            [mutableSet removeObject:weaSelf.pushToAddSubTaskCtlSubTaskModel];
            [mutableSet addObject:subTask];
            [weaSelf.taskModel addSubTasks:mutableSet];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:4];
                [weaSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            });
        };
       
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}
#pragma mark - creatTask
- (Task*)taskModel
{
    if (_taskModel) {
        return _taskModel ;
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.context];
    Task *task = [[Task alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
    
     self.taskModel = task ;
    
    //默认开始、结束时间
    _taskModel.taskStartTime = CUR_SELECTEDDATE ;
    _taskModel.taskEndTime = [NSDate dateWithTimeInterval:24*60*60 sinceDate:CUR_SELECTEDDATE];
    
    return _taskModel ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {

        return self.taskModel.subTasks.count + 2;
    }
    NSArray *arr = @[@(3) , @(1), @(1) , @(1)];
    
    return [arr[section] integerValue];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        self.taskNameTF = (UITextField*)[cell viewWithTag:1];
        return cell ;
    }
    
    if (indexPath.section == 4 && indexPath.row != 0) {
        
        if (indexPath.row == self.taskModel.subTasks.count + 1) {
            AddSubTaskActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSubTaskActionCell" forIndexPath:indexPath];
            return cell ;
        }
        AddSubTaskContentCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSubTaskContentCell" forIndexPath:indexPath];
        NSArray *subTaskArr = [self.taskModel.subTasks allObjects];
        [cell configureCellWithTableView:tableView indexPath:indexPath subTaskl:subTaskArr[indexPath.row - 1]];
        return cell ;
        
    }
    
    AddTaskSetTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTaskSetTimeCell" forIndexPath:indexPath];
    [cell configureCellWithTableView:tableView indexPath:indexPath];
    return cell ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60.0;
    }
    
    return 44.0 ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return ;
    }
    
    
    switch (indexPath.section) {
        case 0:
            [self didSelectedFirstSection:indexPath];
            break;
        case 1:
            [self didSelectedSecondSection:indexPath];
            break;
        case 2:
            [self didSelectedThreeSection:indexPath];
            break;
        case 3:
            [self didSelectedFourSection:indexPath];
            break;
        case 4:
            [self didSelectedFiveSection:indexPath];
            break;
            
        default:
            break;
    }
    
}
#pragma mark - private fun
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    self.taskModel = nil ;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    
    if (self.taskNameTF.text.length == 0) {
        [[ [UIAlertView alloc]initWithTitle:nil message:@"任务名称不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
        return ;
    }
    
    self.taskModel.taskName = self.taskNameTF.text;
    self.taskModel.taskCreatTime = [NSDate date];
    
    //创建的是那天的task
    
    NSString *dayDate = [Tool stringFromFomate:CUR_SELECTEDDATE formate:DATE_FORMATE];
    self.taskModel.taskTheDate= [Tool dateFromFomate:dayDate formate:DATE_FORMATE] ;
    
    
    if (self.taskModel.taskStartTime == nil) {
        self.taskModel.taskStartTime = CUR_SELECTEDDATE ;
    }
    
    if (self.taskModel.taskEndTime == nil) {
        self.taskModel.taskEndTime = [NSDate dateWithTimeInterval:24*60*60 sinceDate:CUR_SELECTEDDATE];
    }
    
    
    self.taskModel.creatTaskUser = [CoreDataModelService fetchUserByName:DEVICE_NAME];
    
    
    NSError *error = nil ;
    if (![self.context save:&error]) {
        NSLog(@"add user fail");
    }
  
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_ADDTASKCOMPLETE object:self.taskModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ClickRow
#pragma mark - 设置时间 、执行者
- (void)didSelectedFirstSection:(NSIndexPath*)indexPath
{
    WS(weakself);
    //设置时间
    if (indexPath.row == 1) {
        DatePickerViewController *dataPickerCtl = [self fetchViewControllerByIdentifier:@"DatePickerController"];
        dataPickerCtl.typeInt = 0 ;
        dataPickerCtl.startTime = self.taskModel.taskStartTime ;
        dataPickerCtl.endTime = self.taskModel.taskEndTime;
        dataPickerCtl.scheuleDateBlock = ^(NSDate *startTime , NSDate *endTime){
            
            //保存时间
            weakself.taskModel.taskStartTime = startTime ;
            weakself.taskModel.taskEndTime = endTime ;
            
           
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
                
                AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[weakself.tableView cellForRowAtIndexPath:indexPath];
                cell.cellTextLabel.text = [NSString stringWithFormat:@"%@-%@" , startString , endString];
                cell.cellEndTextLabel.text = @"";
            });
            
            
        };
        [self.navigationController pushViewController:dataPickerCtl animated:YES];

    }
    //执行者
    else if (indexPath.row == 2){
        ExecutorController *executor = [self fetchViewControllerByIdentifier:@"ExecutorController"];
        
        executor.executorUser = weakself.taskModel.executor ;
        
        executor.selectExecutorBlock = ^(User *user){
            
            //保存执行者
            weakself.taskModel.executor = user ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[weakself.tableView cellForRowAtIndexPath:indexPath];
                cell.cellEndTextLabel.text = user.userName ;
                cell.cellEndTextLabel.hidden = NO ;
            });
           
        };
        [self.navigationController pushViewController:executor animated:YES];

    }
}
#pragma mark - 参与者
- (void)didSelectedSecondSection:(NSIndexPath*)indexPath
{
    WS(weaSelf);
    ExecutorController *executor = [self fetchViewControllerByIdentifier:@"ExecutorController"];
    
    executor.follows = [NSMutableArray arrayWithArray:[self.taskModel.followers allObjects]];
    
    executor.selectFollowersBlock = ^(NSMutableArray *followers){
        
        //参与者
        NSSet *set = [NSSet setWithArray:followers];
        weaSelf.taskModel.followers = set ;
        
        NSMutableString *appNameStr = [NSMutableString new];
        for (User *user in followers) {
                [appNameStr appendFormat:@" %@" , user.userName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellEndTextLabel.text = appNameStr ;
        });
        
        
    };
    [self.navigationController pushViewController:executor animated:YES];
}
#pragma mark - 普通(任务紧急程度)
- (void)didSelectedThreeSection:(NSIndexPath*)indexPath
{
    WS(weaSelf);
    
    SetTagController *setTagCtl = [self fetchViewControllerByIdentifier:@"SetTagController"];
    setTagCtl.curTaskTagType = OrdinaryType ;
    setTagCtl.selectedTaskTagBlock = ^(NSInteger selectedTaskTag){
        //
       weaSelf.taskModel.taskTag = [NSNumber numberWithInteger:selectedTaskTag];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.taskTagLabel.hidden = NO ;
            switch (selectedTaskTag) {
                case 0:
                    cell.taskTagLabel.backgroundColor = SET_TASK_TAG0 ;
                    break;
                case 1:
                    cell.taskTagLabel.backgroundColor = SET_TASK_TAG1 ;
                    break;
                case 2:
                    cell.taskTagLabel.backgroundColor = SET_TASK_TAG2 ;
                    break;
                case 3:
                    cell.taskTagLabel.backgroundColor = SET_TASK_TAG3 ;
                    break;
                    
                default:
                    break;
            }
        });
       
        
    };
    [self.navigationController pushViewController:setTagCtl animated:YES];
}
#pragma mark - 附件
- (void)didSelectedFourSection:(NSIndexPath*)indexPath
{
    PhtotoController *photoCtl = [[PhtotoController alloc]init];
    photoCtl.taskModel = self.taskModel ;
    photoCtl.annexUploadCountBlock = ^(NSInteger annexUploadCount){
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellEndTextLabel.text = [NSString stringWithFormat:@"%d" , (int)annexUploadCount];
        });
        
    };
    [self.navigationController pushViewController:photoCtl animated:YES];

}
#pragma mark - 添加子任务
- (void)didSelectedFiveSection:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        return ;
    }
    if (indexPath.row == self.taskModel.subTasks.count + 1) {
        return ;
    }
   
    self.pushToAddSubTaskCtlSubTaskModel = [self.taskModel.subTasks allObjects][indexPath.row - 1];
    if (self.pushToAddSubTaskCtlSubTaskModel) {
        _subTaskDetailCtl.subTask = _pushToAddSubTaskCtlSubTaskModel ;
    }
}
@end
