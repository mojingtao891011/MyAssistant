//
//  TestAddScheduleController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddScheduleController.h"
#import "DatePickerController.h"
#import "RepeatRemindController.h"
#import "PhtotoController.h"
#import "FriendListController.h"
#import "RemindTimeController.h"
#import "LoginController.h"
#import "BaseNavgationController.h"

#import "AddScheduleContentCell.h"
#import "AddSubRemindCell.h"
#import "AddScheduleTimeCell.h"
#import "SubRemindContentCell.h"

#import "Schedule.h"
#import "User.h"
#import "SubRemind.h"
#import "CoreDataModelService.h"


@interface AddScheduleController ()<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate>

@property (nonatomic , retain)NSManagedObjectContext   *context ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , retain)UITextField *scheduleNameTF;
@property (nonatomic , retain)UITextField *scheduleAddressTF;
@property (nonatomic , copy)NSString        *scheduleName ;
@property (nonatomic , assign)BOOL          isShowMore ;

@end

@implementation AddScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self _initBarButtonItem];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    if (!_isCreatSchedule) {
        _isShowMore = YES ;
    }
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
#pragma mark - Model
- (Schedule*)scheduleModel
{
    if (_scheduleModel) {
        return _scheduleModel ;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:self.context];
    
    Schedule *schedule = [[Schedule alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
    
    self.scheduleModel = schedule ;
    
    //默认时间
    self.scheduleModel.schedulestartTime = [NSDate date] ;
    self.scheduleModel.scheduleEndTime = [NSDate dateWithTimeInterval:60*60 sinceDate:self.scheduleModel.schedulestartTime];
    
    //提醒
    NSEntityDescription *subRemindEntity = [NSEntityDescription entityForName:@"SubRemind" inManagedObjectContext:self.context];
    SubRemind *subRemind = [[SubRemind alloc]initWithEntity:subRemindEntity insertIntoManagedObjectContext:self.context];
    subRemind.subRemindNumber = [NSNumber numberWithInt:0];
    [self.scheduleModel addSubRemindsObject:subRemind];
    
    
    return _scheduleModel ;
}
#pragma mark - Action
- (void)leftBarButtonItemAction:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonItemAction:(UIButton*)sender
{
    
    
    if (self.scheduleNameTF.text.length == 0) {
        [[ [UIAlertView alloc]initWithTitle:nil message:@"日程名称不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
        return ;
    }
    
    //名称
    self.scheduleModel.scheduleName = self.scheduleNameTF.text ;
    
    //地点
    if (self.scheduleAddressTF.text.length != 0) {
        self.scheduleModel.scheduleAddress = self.scheduleAddressTF.text ;
    }
    
    
    if (self.scheduleModel.schedulestartTime == nil) {
        self.scheduleModel.schedulestartTime = CUR_SELECTEDDATE;
        NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:60*60];
        self.scheduleModel.scheduleEndTime = endTime ;
        
        //创建的是那天的schedule（到天）
        self.scheduleModel.scheduleTheDay =  CUR_SELECTEDDATE;
        
    }
    else{
        NSCalendar* calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self.scheduleModel.schedulestartTime];
        NSDate *date = [calendar dateFromComponents:comp1];
        self.scheduleModel.scheduleTheDay = date ;
    }
    
    self.scheduleModel.scheduleCreatTime = [NSDate date];
        
    
    User *user = [CoreDataModelService fetchUserByName:DEVICE_NAME];
    
    self.scheduleModel.creatScheduleUser = user ;
    
    
    
    if (![self.context save:nil]) {
        
        debugLog(@"creat schedule fail");
    }
    
    if (_isCreatSchedule) {
         [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_ADDSCHEDULECOMPLETE object:self.scheduleModel];
    }
   
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_MODIFICATION_SCHEDULE object:self.scheduleModel];
    }];
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.scheduleName = textField.text ;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isShowMore) {
        return 4 ;
    }
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *arr = @[ @(3+self.scheduleModel.subReminds.count),@(1), @(1), @(1)];
    
    return [arr[section ] integerValue];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一段
    if (indexPath.section == 0 ) {
        //日程标题
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleNameCell" forIndexPath:indexPath];
            self.scheduleNameTF = (UITextField*)[cell viewWithTag:1];
            if (self.scheduleModel.scheduleName) {
                 self.scheduleNameTF.text = self.scheduleModel.scheduleName;
            }
            else{
                self.scheduleNameTF.text = self.scheduleName ;
            }
           
            return cell ;
        }
        //日程时间
        else if (indexPath.row == 1){
            AddScheduleTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleTimeCell" forIndexPath:indexPath];
            [cell configureCellWith:tableView indexPath:indexPath scheduleModel:self.scheduleModel];
            return cell ;
        }
        //提醒时间、重复方式
        else{
            AddScheduleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleContentCell" forIndexPath:indexPath];
            [cell configureCellWithTableView:tableView indexPath:indexPath scheduleModel:self.scheduleModel];
            return cell ;
        }
       
    }
    //第二段
    if (indexPath.section == 1 && !_isShowMore) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleMoreCell" forIndexPath:indexPath];
        return cell ;
    }
    //地点
    if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleAddressCell" forIndexPath:indexPath];
        self.scheduleAddressTF = (UITextField*)[cell viewWithTag:2];
        self.scheduleAddressTF.text = self.scheduleModel.scheduleAddress;
        return cell ;
    }
    //其他
    AddScheduleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleContentCell" forIndexPath:indexPath];
    [cell configureCellWithTableView:tableView indexPath:indexPath scheduleModel:self.scheduleModel];
    return cell ;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row < 2) {
        return 65.0;
    }
    
    return 44.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                return ;
            }
            [self didSelectedFirstSection:indexPath];
        }
            break;
        case 1:
        {
            if (_isShowMore) {
                 [self didSelectedSecondSection:indexPath];
            }
            else{
                _isShowMore = YES ;
                [tableView reloadData];
            }
        }
            break;
        case 2:
            //[self didSelectedSecondSection:indexPath];
            break;
        case 3:
            [self didSelectedFourSection:indexPath];
            break;
            
        default:
            break;
    }
}
#pragma mark - 日程时间、提醒、重复
- (void)didSelectedFirstSection:(NSIndexPath*)indexPath
{
   
    WS(weakSelf);
    //日程时间
    if (indexPath.row == 1) {
        DatePickerController *dataPickerCtl = [self fetchViewControllerByIdentifier:@"DatePickerController"];
        dataPickerCtl.typeInt = 2 ;
        dataPickerCtl.startTime = self.scheduleModel.schedulestartTime ;
        dataPickerCtl.endTime = [NSDate dateWithTimeInterval:60*60 sinceDate:self.scheduleModel.schedulestartTime];
        dataPickerCtl.scheuleDateBlock = ^(NSDate *startTime , NSDate *endTime){
            
            if ([[startTime laterDate:endTime]isEqualToDate:startTime]) {
                endTime = startTime;
            }
            
            AddScheduleTimeCell *cell = (AddScheduleTimeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSString *startStr = [Tool stringFromFomate:startTime formate:@"MM月dd日"];
            NSString *endStr = [Tool stringFromFomate:endTime formate:@"MM月dd日"];
            
            //start
            
            cell.startDayLabel.text = [NSString stringWithFormat:@"%@  %@" ,startStr , [Tool curDateOfWeek:startTime]];
            cell.startTimeLabel.text = [NSString stringWithFormat:@"开始  %@",[Tool stringFromFomate:startTime formate:@"HH:mm"]];
            
            //end
            cell.endDayLabel.text = [NSString stringWithFormat:@"%@  %@" ,endStr , [Tool curDateOfWeek:endTime]];
            cell.endTimeLabel.text =  [NSString stringWithFormat:@"结束  %@",[Tool stringFromFomate:endTime formate:@"HH:mm"]];
            
            //保存时间
            weakSelf.scheduleModel.schedulestartTime = startTime ;
            weakSelf.scheduleModel.scheduleEndTime = endTime ;
            
        };
        [self.navigationController pushViewController:dataPickerCtl animated:YES];
        
    }
    //重复
    else if (indexPath.row == 3 + self.scheduleModel.subReminds.count - 1){
        
       // __weak TestAddScheduleController *weakSelf = self ;
        
        RepeatRemindController *repeatRemindCtl = [self fetchViewControllerByIdentifier:@"RepeatRemindController"] ;
        repeatRemindCtl.curRepeatType = [self.scheduleModel.schedulerepeat intValue];
        
        SubRemind *subRemind = [CoreDataModelService fetchSubRemindBySubRemindNumber:0 schedule:self.scheduleModel];
        if (subRemind.subRemindTime) {
            repeatRemindCtl.remindTime = subRemind.subRemindTime ;
        }
        else{
            repeatRemindCtl.remindTime = self.scheduleModel.schedulestartTime ;
        }
        
        repeatRemindCtl.selectedRepeatTypeBlock = ^(NSInteger selectedIndex){
            
            AddScheduleContentCell *cell = (AddScheduleContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.scheduleModel.schedulerepeat = [NSNumber numberWithInteger:selectedIndex];
               
                switch (selectedIndex) {
                    case 0:
                        cell.cellSubTextLabel.text = @"永不";
                        break;
                    case 1:
                       cell.cellSubTextLabel.text = @"每日重复";
                        break;
                    case 2:
                       cell.cellSubTextLabel.text = @"每工作日重复";
                        break;
                    case 3:
                       cell.cellSubTextLabel.text = @"每周末重复";
                        break;
                    case 4:
                        cell.cellSubTextLabel.text = @"每月重复";
                        break;
                    case 5:
                        cell.cellSubTextLabel.text = @"每年重复";
                        break;
                    case 6:
                        cell.cellSubTextLabel.text = @"自定义";
                        break;
                    default:
                        break;
                }
                
                //保存重复
                weakSelf.scheduleModel.schedulerepeat = [NSNumber numberWithInteger:selectedIndex];
            });
        };
         [self.navigationController pushViewController:repeatRemindCtl animated:YES];
        
    }
    //提醒
    else {
        
        RemindTimeController *remindCtl = [self fetchViewControllerByIdentifier:@"RemindTimeController"];
        remindCtl.scheduleStartTime = self.scheduleModel.schedulestartTime ;
       
        switch (indexPath.row) {
            case 2:
                remindCtl.subRemindNumber = 0 ;
                break;
            case 3:
                remindCtl.subRemindNumber = 1 ;
                break;
            case 4:
                remindCtl.subRemindNumber = 2 ;
                break;
                
            default:
                break;
        }
        
        remindCtl.remindDateBlock = ^(NSDate *date , NSString *remindType , NSInteger subRemindNumber){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AddScheduleContentCell *cell = (AddScheduleContentCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath];

                if (remindType) {
                    cell.cellSubTextLabel.text =  remindType ;
                }else{
                    if (date) {
                        cell.cellSubTextLabel.text = [Tool stringFromFomate:date formate:@"MM-dd HH:mm"];
                    }
                    else{
                        cell.cellSubTextLabel.text = @"无";
                    }
                    
                }
                
                if (![remindType isEqualToString:@"无"]) {
                    
                    SubRemind *subRemind = [CoreDataModelService fetchSubRemindBySubRemindNumber:subRemindNumber schedule:weakSelf.scheduleModel];
                    if (subRemind) {
                        subRemind.subRemindTime = date ;
                        subRemind.subRemindType = remindType ;
                        subRemind.schedule = weakSelf.scheduleModel;
                        
                        SubRemind *subRemind1 = [CoreDataModelService fetchSubRemindBySubRemindNumber:subRemindNumber + 1 schedule:weakSelf.scheduleModel];
                        if (subRemindNumber < 2 && subRemind1== nil) {
                            //添加子提醒
                            NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubRemind" inManagedObjectContext:weakSelf.context];
                            SubRemind *subRemind1 = [[SubRemind alloc]initWithEntity:entity insertIntoManagedObjectContext:weakSelf.context];
                            subRemind1.subRemindType = @"无" ;
                            subRemind1.subRemindNumber = [NSNumber numberWithInteger:subRemindNumber + 1];
                            subRemind1.schedule = weakSelf.scheduleModel ;
                        }
                    }
                    
                    //刷新tableView
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

                }
                
            });
        };
        [self.navigationController pushViewController:remindCtl animated:YES];
    }

}

#pragma mark - 参与者
- (void)didSelectedSecondSection:(NSIndexPath*)indexPath
{
    //如果没有登录
    WS(weaSelf);
    BaseNavgationController *loginNavCtl = [self fetchViewControllerByIdentifier:@"LoginNavCtl"];
    LoginController *loginCtl = (LoginController*)loginNavCtl.topViewController ;
    loginCtl.loginControllerBlock = ^(BOOL isLoginSucceed){
        [weaSelf pushFriendListController:indexPath];
    };
    [self presentViewController:loginNavCtl animated:YES completion:nil];
    
}
- (void)pushFriendListController:(NSIndexPath*)indexPath
{
    WS(weaSelf);
    FriendListController *friendListCtl = [self fetchViewControllerByIdentifier:@"FriendListController"];
    friendListCtl.isExecutor = NO ;
    if (self.scheduleModel.scheduleFollowers.count != 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.scheduleModel.scheduleFollowers allObjects]];
        friendListCtl.colletionDataSources = [arr mutableCopy];
    }
    friendListCtl.selectedFriendBlock = ^(NSMutableArray *userArr){
        //参与者
        NSSet *set = [NSSet setWithArray:userArr];
        weaSelf.scheduleModel.scheduleFollowers = set ;
        
        NSMutableString *appNameStr = [NSMutableString new];
        for (User *user in userArr) {
            [appNameStr appendFormat:@" %@" , user.userName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AddScheduleContentCell *cell = (AddScheduleContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellSubTextLabel.text= appNameStr ;
        });
        
    };
    [self.navigationController pushViewController:friendListCtl animated:YES];

}
#pragma mark - 添加附件
- (void)didSelectedFourSection:(NSIndexPath*)indexPath
{
    
    
    PhtotoController *photoCtl = [[PhtotoController alloc]init];
    photoCtl.scheduleModel = self.scheduleModel ;
    photoCtl.annexUploadCountBlock = ^(NSInteger annexUploadCount , id model){
        //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scheduleModel = model ;
            AddScheduleContentCell *cell = (AddScheduleContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellSubTextLabel.text= [NSString stringWithFormat:@"%d" , (int)annexUploadCount];
            
        });
    };
    [self.navigationController pushViewController:photoCtl animated:YES];
    
}
@end
