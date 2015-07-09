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
#import "ExecutorController.h"
#import "PhtotoController.h"
#import "DatePickerController.h"
#import "SubRemindController.h"

#import "AddScheduleContentCell.h"
#import "AddSubRemindCell.h"
#import "AddScheduleTimeCell.h"

#import "Schedule.h"
#import "User.h"
#import "SubRemind.h"
#import "CoreDataModelService.h"


@interface AddScheduleController ()<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate>

@property (nonatomic , retain)Schedule      *scheduleModel ;
@property (nonatomic , retain)NSManagedObjectContext   *context ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , retain)UITextField *scheduleNameTF;
@property (nonatomic , retain)UITextField *scheduleAddressTF;

@end

@implementation AddScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
//    //默认选中的时间为今天
//    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"curSelectedDate"];
//    [[NSUserDefaults standardUserDefaults]synchronize];

    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)cancelAction:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveScheduleModel:(id)sender {
    
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
    }
    
    self.scheduleModel.scheduleCreatDetailTime = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:CUR_SELECTEDDATE];
    NSString *creatScheduleDay = [NSString stringWithFormat:@"%lu月%lu日      星期%lu" ,  dateComponents.month , dateComponents.day , dateComponents.weekday - 1 ];
    self.scheduleModel.scheduleCreatDay = creatScheduleDay ;
    
    //创建schedule的日期（到天）
    NSString *dateStr = [Tool stringFromFomate:CUR_SELECTEDDATE formate:DATE_FORMATE];
    self.scheduleModel.scheduleCreatDateDay = [Tool dateFromFomate:dateStr formate:DATE_FORMATE];
    
    User *user = [CoreDataModelService fetchUserByName:DEVICE_NAME];
    
    self.scheduleModel.creatScheduleUser = user ;
    
    
    
    if (![self.context save:nil]) {
        
        debugLog(@"creat schedule fail");
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_ADDSCHEDULECOMPLETE object:self.scheduleModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    

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
//    if (section == 0) {
//        return  self.scheduleModel.subReminds.count *2 + 5 ;
//    }
    NSArray *arr = @[ @(5),@(1), @(1), @(1)];
    
    return [arr[section ] integerValue];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //日程标题
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleNameCell" forIndexPath:indexPath];
        self.scheduleNameTF = (UITextField*)[cell viewWithTag:1];
        return cell ;
    }
    //日程时间
    if (indexPath.section == 0 && indexPath.row == 1) {
        AddScheduleTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleTimeCell" forIndexPath:indexPath];
        [cell configureCellWith:tableView indexPath:indexPath scheduleModel:self.scheduleModel];
        return cell ;
    }
    //添加多次提醒
    if (indexPath.section == 0 && indexPath.row == 4) {
        AddSubRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSubRemindCell" forIndexPath:indexPath];
        
        return cell ;
    }
    //地点
    if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddScheduleAddressCell" forIndexPath:indexPath];
        self.scheduleAddressTF = (UITextField*)[cell viewWithTag:2];
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
    
    if(indexPath.section == 0 && indexPath.row == 4){
        
        SubRemindController *subRemindCtl = [self fetchViewControllerByIdentifier:@"SubRemindController"];
        [self.navigationController pushViewController:subRemindCtl animated:YES];
        
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
            NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:startTime];
            
            cell.startDayLabel.text = [NSString stringWithFormat:@"%@  周%d" ,startStr , (int)dateComponents.weekday];
            cell.startTimeLabel.text = [NSString stringWithFormat:@"开始  %@",[Tool stringFromFomate:startTime formate:@"HH:mm"]];
            
            //end
            NSDateComponents *dateComponents1 = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:endTime];
            cell.endDayLabel.text = [NSString stringWithFormat:@"%@  周%d" ,endStr , (int)dateComponents1.weekday];
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
    __weak AddScheduleController *weakSelf = self ;
    
    ExecutorController *executor = [self fetchViewControllerByIdentifier:@"ExecutorController"];
    
    executor.follows = [NSMutableArray arrayWithArray:[self.scheduleModel.scheduleFollowers allObjects]];
    
    executor.selectFollowersBlock = ^(NSMutableArray *followers){
        
        //参与者
        NSSet *set = [NSSet setWithArray:followers];
       weakSelf.scheduleModel.scheduleFollowers = set ;
        
        NSMutableString *appNameStr = [NSMutableString new];
        for (User *user in followers) {
            [appNameStr appendFormat:@" %@" , user.userName];
        }
        
       AddScheduleContentCell *cell = (AddScheduleContentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.cellSubTextLabel.text= appNameStr ;
        
    };
    [self.navigationController pushViewController:executor animated:YES];

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
