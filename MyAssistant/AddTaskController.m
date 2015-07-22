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
#import "DatePickerController.h"
#import "PhtotoController.h"
#import "SetTagController.h"
#import "AddSubTaskController.h"
#import "Task.h"
#import "User.h"
#import "CoreDataStack.h"
#import "CoreDataModelService.h"
#import "Comment.h"
#import "AddSubTaskActionCell.h"
#import "AddSubTaskController.h"
#import "FriendListController.h"

@interface AddTaskController ()<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate>

@property (retain, nonatomic)UITextField *taskNameTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , retain)NSManagedObjectContext        *context ;

@property (nonatomic , retain)AddSubTaskController *subTaskDetailCtl  ;
@property (nonatomic , retain)SubTask                            *pushToAddSubTaskCtlSubTaskModel;
@property (nonatomic , assign)BOOL   isShowMore;

@end

@implementation AddTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    
    self.context = [CoreDataStack shareManaged].managedObjectContext;
    
    if (!_isCreatTask) {
        _isShowMore = YES ;
    }
    
    [self _initBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
- (void)_initBarButtonItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barButtonItem ;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItemRight = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barButtonItemRight ;
    
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
    _taskModel.taskStartTime = [NSDate date] ;
    _taskModel.taskEndTime = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.taskModel.taskStartTime];
    
    return _taskModel ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isShowMore) {
        return 5 ;
    }
    return 3 ;
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
        self.taskNameTF.text = self.taskModel.taskName ;
        return cell ;
    }
    //更多
    if (!_isShowMore && indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskMoreCell" forIndexPath:indexPath];
        return cell;
    }
    //子任务
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
    [cell configureCellWithTableView:tableView indexPath:indexPath taskModel:self.taskModel];
    return cell ;
}
#pragma mark - UITableViewDelegate
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
            if (_isShowMore) {
                [self didSelectedThreeSection:indexPath];
            }
            else{
                _isShowMore = YES ;
                [tableView reloadData];
            }
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
- (void)leftBarButtonItemAction:(UIButton*)sender
{
    self.taskModel = nil ;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonItemAction:(UIButton*)sender
{
    
    
    if (self.taskNameTF.text.length == 0) {
        [[ [UIAlertView alloc]initWithTitle:nil message:@"任务名称不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
        return ;
    }
    
    self.taskModel.taskName = self.taskNameTF.text;
    self.taskModel.taskCreatTime = [NSDate date];
    
    
    if (self.taskModel.taskStartTime == nil) {
        self.taskModel.taskStartTime = CUR_SELECTEDDATE ;
        //创建的是那天的task
        self.taskModel.taskTheDate= CUR_SELECTEDDATE ;
    }
    else{
        NSCalendar* calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self.taskModel.taskStartTime];
        NSDate *date = [calendar dateFromComponents:comp1];
        self.taskModel.taskTheDate = date ;
    }
    
    if (self.taskModel.taskEndTime == nil) {
        self.taskModel.taskEndTime = [NSDate dateWithTimeInterval:24*60*60 sinceDate:CUR_SELECTEDDATE];
    }
    
    
    self.taskModel.creatTaskUser = [CoreDataModelService fetchUserByName:DEVICE_NAME];
    
    
    NSError *error = nil ;
    if (![self.context save:&error]) {
        NSLog(@"add user fail");
    }
    
    if (_isCreatTask) {
         [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_ADDTASKCOMPLETE object:self.taskModel];
    }
   
    
    [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_MODIFICATION_TASK object:self.taskModel];
    }];

}
#pragma mark - ClickRow
#pragma mark - 设置时间 、执行者
- (void)didSelectedFirstSection:(NSIndexPath*)indexPath
{
    WS(weakself);
    //设置时间
    if (indexPath.row == 1) {
        DatePickerController *dataPickerCtl = [self fetchViewControllerByIdentifier:@"DatePickerController"];
        dataPickerCtl.typeInt = 0 ;
        dataPickerCtl.startTime = self.taskModel.taskStartTime ;
        dataPickerCtl.endTime = self.taskModel.taskEndTime;
        dataPickerCtl.scheuleDateBlock = ^(NSDate *startTime , NSDate *endTime){
            
            if ([[startTime laterDate:endTime]isEqualToDate:startTime]) {
                endTime = [NSDate dateWithTimeInterval:24*60*60 sinceDate:startTime];
            }
            
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
        
        FriendListController *friendListCtl = [self fetchViewControllerByIdentifier:@"FriendListController"];
        friendListCtl.isExecutor = YES ;
        if (self.taskModel.executor) {
             friendListCtl.colletionDataSources = [NSMutableArray arrayWithObject:self.taskModel.executor];
        }
        friendListCtl.selectedFriendBlock = ^(NSMutableArray *userArr){
            //保存执行者
            User *user = [userArr firstObject];
            weakself.taskModel.executor = user ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[weakself.tableView cellForRowAtIndexPath:indexPath];
                cell.cellEndTextLabel.text = user.userName ;
                cell.cellEndTextLabel.hidden = NO ;
            });

        };
        [self.navigationController pushViewController:friendListCtl animated:YES];
    }
}
#pragma mark - 参与者
- (void)didSelectedSecondSection:(NSIndexPath*)indexPath
{
    WS(weaSelf);
    FriendListController *friendListCtl = [self fetchViewControllerByIdentifier:@"FriendListController"];
    friendListCtl.isExecutor = NO ;
    if ([self.taskModel.followers allObjects].count != 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.taskModel.followers allObjects]];
        friendListCtl.colletionDataSources = [arr mutableCopy];
    }
    friendListCtl.selectedFriendBlock = ^(NSMutableArray *userArr){
        //参与者
        NSSet *set = [NSSet setWithArray:userArr];
        weaSelf.taskModel.followers = set ;
        
        NSMutableString *appNameStr = [NSMutableString new];
        for (User *user in userArr) {
            [appNameStr appendFormat:@" %@" , user.userName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AddTaskSetTimeCell *cell = (AddTaskSetTimeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellEndTextLabel.text = appNameStr ;
        });
        
    };
    [self.navigationController pushViewController:friendListCtl animated:YES];

}
#pragma mark - 普通(任务紧急程度)
- (void)didSelectedThreeSection:(NSIndexPath*)indexPath
{
    WS(weaSelf);
    
    SetTagController *setTagCtl = [self fetchViewControllerByIdentifier:@"SetTagController"];
    setTagCtl.curTaskTagType = self.taskModel.taskTag.intValue ;
    setTagCtl.selectedTaskTagBlock = ^(NSInteger selectedTaskTag){
        //
       weaSelf.taskModel.taskTag = [NSNumber numberWithInteger:selectedTaskTag];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weaSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
       
        
    };
    [self.navigationController pushViewController:setTagCtl animated:YES];
}
#pragma mark - 附件
- (void)didSelectedFourSection:(NSIndexPath*)indexPath
{
    PhtotoController *photoCtl = [[PhtotoController alloc]init];
    photoCtl.taskModel = self.taskModel ;
    photoCtl.annexUploadCountBlock = ^(NSInteger annexUploadCount , id model){
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            self.taskModel = model ;
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
