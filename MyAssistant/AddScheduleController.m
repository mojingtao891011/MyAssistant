//
//  TestAddScheduleController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddScheduleController.h"
#import "DatePickerViewController.h"
#import "RepeatRemindController.h"
#import "PhtotoController.h"
#import "DatePickerController.h"
#import "SubRemindController.h"
#import "FriendListController.h"

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

@end

@implementation AddScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self _initBarButtonItem];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
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
    self.scheduleModel.schedulestartTime = CUR_SELECTEDDATE ;
    self.scheduleModel.scheduleEndTime = [NSDate dateWithTimeInterval:60*60 sinceDate:CUR_SELECTEDDATE];
    
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
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 添加自提醒
- (void)addSubRemind:(NSIndexPath*)indexPath
{
    //当点击添加子提醒时，如果子提醒个数已大于3个则不能再添加
    if (self.scheduleModel.subReminds.count + 4 == indexPath.row && self.scheduleModel.subReminds.count >= 3) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"最多只能添加三个子提醒" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确 定", nil]show ];
        return ;
    }
    
    WS(weaSelf);
    SubRemindController *subRemindCtl = [self fetchViewControllerByIdentifier:@"SubRemindController"];
    if (self.scheduleModel.subReminds.count != 0 && indexPath.row != self.scheduleModel.subReminds.count + 4) {
        subRemindCtl.subRemindModel = [self.scheduleModel.subReminds allObjects][indexPath.row -4];
    }
   
    subRemindCtl.subRemindBlock = ^(NSDate *date , NSInteger remindType , BOOL isCreatRemind){
        
        NSMutableSet *mutableSet = [NSMutableSet setWithSet:weaSelf.scheduleModel.subReminds];
    
        if (isCreatRemind) {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubRemind" inManagedObjectContext:weaSelf.context];
            SubRemind *subremindModel = [[SubRemind alloc]initWithEntity:entity insertIntoManagedObjectContext:weaSelf.context];
            subremindModel.subRemindTime = date ;
            subremindModel.subRemindType =[NSNumber numberWithInteger: remindType] ;
            [mutableSet addObject:subremindModel];
        }
        else{
            SubRemind *subRemind = [self.scheduleModel.subReminds allObjects][indexPath.row -4];
            [mutableSet removeObject:subRemind];
    
            subRemind.subRemindTime = date ;
            subRemind.subRemindType = [NSNumber numberWithInteger:remindType];
            [mutableSet addObject:subRemind];
            
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subRemindTime" ascending:YES];
        
        if (mutableSet.count < 4) {
            weaSelf.scheduleModel.subReminds = [NSSet setWithArray:[mutableSet sortedArrayUsingDescriptors:@[sort]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weaSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic ];
        });
    };
    
    subRemindCtl.deleteRemindBlock = ^{
         NSMutableSet *mutableSet = [NSMutableSet setWithSet:weaSelf.scheduleModel.subReminds];
        SubRemind *subRemind = [self.scheduleModel.subReminds allObjects][indexPath.row -4];
        [mutableSet removeObject:subRemind];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subRemindTime" ascending:YES];
         weaSelf.scheduleModel.subReminds = [NSSet setWithArray:[mutableSet sortedArrayUsingDescriptors:@[sort]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weaSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic ];
        });
    };
    
    [self.navigationController pushViewController:subRemindCtl animated:YES];
    
    return ;
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *arr = @[ @(5+self.scheduleModel.subReminds.count),@(1), @(1), @(1)];
    
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
            self.scheduleNameTF.text = self.scheduleModel.scheduleName;
            return cell ;
        }
        //日程时间
        else if (indexPath.row == 1){
            AddScheduleTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleTimeCell" forIndexPath:indexPath];
            [cell configureCellWith:tableView indexPath:indexPath scheduleModel:self.scheduleModel];
            return cell ;
        }
        //提醒时间、重复方式
        else if (indexPath.row == 2 || indexPath.row == 3){
            AddScheduleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleContentCell" forIndexPath:indexPath];
            [cell configureCellWithTableView:tableView indexPath:indexPath scheduleModel:self.scheduleModel];
            return cell ;
        }
        //添加多次提醒
        else if (indexPath.row == self.scheduleModel.subReminds.count + 4){
            AddSubRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSubRemindCell" forIndexPath:indexPath];
            return cell ;
        }
        //子提醒
        else{
            SubRemindContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubRemindContentCell" forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath scheduleModel:self.scheduleModel];
            return cell ;
        }
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
            //日程时间、提醒、重复
            if(indexPath.row < 4){
                 [self didSelectedFirstSection:indexPath];
            }
            //添加子提醒\子提醒
            else{
                
                [self addSubRemind:indexPath];

            }
        }
            break;
        case 1:
            [self didSelectedSecondSection:indexPath];
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
        DatePickerViewController *dataPickerCtl = [self fetchViewControllerByIdentifier:@"DatePickerController"];
        dataPickerCtl.typeInt = 2 ;
        dataPickerCtl.startTime = self.scheduleModel.schedulestartTime ;
        dataPickerCtl.endTime = [NSDate dateWithTimeInterval:60*60 sinceDate:self.scheduleModel.schedulestartTime];
        dataPickerCtl.scheuleDateBlock = ^(NSDate *startTime , NSDate *endTime){
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
    //提醒
    else if (indexPath.row == 2){
        DatePickerController *dataPickerCtl = [self fetchViewControllerByIdentifier:@"DatePickerViewController"];
        dataPickerCtl.curDate = self.scheduleModel.scheduleRemindTime ;
        dataPickerCtl.datePickerShowMode = DatePickerModeTime ;
        
        dataPickerCtl.selectedDateBlock = ^(NSDate *date){
            dispatch_async(dispatch_get_main_queue(), ^{
                AddScheduleContentCell *cell = (AddScheduleContentCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
                cell.cellTextLabel.text = [Tool stringFromFomate:date formate:@"HH:mm"];
                weakSelf.scheduleModel.scheduleRemindTime = date ;
                
            });
        };
        
        [self.navigationController pushViewController:dataPickerCtl animated:YES];
        
    }
    //重复
    else if (indexPath.row == 3){
        
       // __weak TestAddScheduleController *weakSelf = self ;
        
        RepeatRemindController *repeatRemindCtl = [self fetchViewControllerByIdentifier:@"RepeatRemindController"] ;
        repeatRemindCtl.curRepeatType = [self.scheduleModel.schedulerepeat intValue];
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
                       cell.cellSubTextLabel.text = @"每周重复";
                        break;
                    case 3:
                       cell.cellSubTextLabel.text = @"每月重复";
                        break;
                    case 4:
                        cell.cellSubTextLabel.text = @"每年重复";
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
    
}

#pragma mark - 参与者
- (void)didSelectedSecondSection:(NSIndexPath*)indexPath
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
    photoCtl.annexUploadCountBlock = ^(NSInteger annexUploadCount){
        //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AddScheduleContentCell *cell = (AddScheduleContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellSubTextLabel.text= [NSString stringWithFormat:@"%d" , (int)annexUploadCount];
            

        });
    };
    [self.navigationController pushViewController:photoCtl animated:YES];
    
}
@end
