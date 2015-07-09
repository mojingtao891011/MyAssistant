//
//  ScheduleDetailController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/25.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleDetailController.h"
#import "Schedule.h"
#import "User.h"
#import "EditScheduleController.h"
#import "DatePickerController.h"
#import "ExecutorController.h"
#import "RepeatRemindController.h"
#import "PhtotoController.h"
#import "PhotoCell.h"

@interface ScheduleDetailController ()<DatePickerViewControllerDelegate , MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scheduleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleAddress;
@property (weak, nonatomic) IBOutlet UILabel *scheduleDescribcLabel;

@property (weak, nonatomic) IBOutlet UILabel *scheduleStartTime;
@property (weak, nonatomic) IBOutlet UILabel *scheduleEndtime;
@property (weak, nonatomic) IBOutlet UILabel *scheduleFollowers;
@property (weak, nonatomic) IBOutlet UILabel *scheduleAnnex;
@property (weak, nonatomic) IBOutlet UILabel *scheduleRemindTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *scheduleRepeatLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describeLabelHeight;

@end

@implementation ScheduleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureScheduleDetailCell];
    
    self.isHidenRightButton   =     YES ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - private funs
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak ScheduleDetailController *weakSelf = self ;
    if ([segue.identifier isEqualToString:@"pushEditScheduleCtlSegue"]) {
        EditScheduleController *editScheduleCtl = segue.destinationViewController ;
        editScheduleCtl.scheduleModel = self.scheduleModel ;
        editScheduleCtl.modityScheduleNameBlock = ^(){
            [weakSelf configureScheduleDetailCell];
            [weakSelf.tableView reloadData];
        };
    }
    else if ([segue.identifier isEqualToString:@"pushDatePickerCtlStartTime"]){
        DatePickerController *datePickerCtl = segue.destinationViewController ;
        datePickerCtl.datePickerViewControllerDelegate = self ;
        datePickerCtl.curDate = self.scheduleModel.schedulestartTime ;
        datePickerCtl.datePickerShowMode = DatePickerModeDateAndTime ;
        datePickerCtl.title = @"设置开始日期";
    }
    else if ([segue.identifier isEqualToString:@"pushDatePickerCtlEndTime"]){
        DatePickerController *datePickerCtl = segue.destinationViewController ;
        datePickerCtl.curDate = self.scheduleModel.scheduleEndTime ;
        datePickerCtl.datePickerShowMode = DatePickerModeDateAndTime ;
        datePickerCtl.title = @"设置结束日期";
        datePickerCtl.selectedDateBlock = ^(NSDate *date){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scheduleEndtime.text = [Tool stringFromFomate:date formate:@"yyyy-MM-dd HH:mm"] ;
                self.scheduleModel.scheduleEndTime = date ;
                if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
                    debugLog(@"modity schedule end time fail");
                }

            });
        };
    }
    else if ([segue.identifier isEqualToString:@"scheduleCtlPushExecutorCtlSegue"]){
        ExecutorController *executorCtl = segue.destinationViewController ;
        
        executorCtl.follows = [NSMutableArray arrayWithArray:[self.scheduleModel.scheduleFollowers allObjects]];
        
        executorCtl.selectFollowersBlock = ^(NSMutableArray *followers){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scheduleModel.scheduleFollowers = [NSSet setWithArray:followers];
                
//                //发送邮件
//                NSMutableArray *csRecipients = [NSMutableArray arrayWithCapacity:followers.count];
//                for (User *followerUser in followers) {
//                    [csRecipients addObject:followerUser.userMail];
//                }
//                
//               
//                [Tool sendMailWithConnent:[NSString stringWithFormat:@"%@ 让你参与%@日程" , DEVICE_NAME ,_scheduleModel.scheduleName ] recipient:csRecipients csRecipients:nil mailDelegate:self];
                
                //
                NSMutableString *followerName = [NSMutableString new] ;
                for (User *user in followers) {
                    [followerName appendFormat:@"%@ " , user.userName];
                }
                self.scheduleFollowers.text = followerName ;
                
                if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
                    debugLog(@"modity schedule followers fail");
                }

            });
            
            
        };

    }
    else if ([segue.identifier isEqualToString:@"PushRepeatCtlSegue"]){
        RepeatRemindController *repeatRemindCtl = segue.destinationViewController ;
        repeatRemindCtl.curRepeatType = [self.scheduleModel.schedulerepeat intValue];
        repeatRemindCtl.selectedRepeatTypeBlock = ^(NSInteger selectedIndex){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scheduleModel.schedulerepeat = [NSNumber numberWithInteger:selectedIndex];
                if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
                    debugLog(@"modity schedule repeat fail");
                }
                switch (selectedIndex) {
                    case 0:
                        self.scheduleRepeatLabel.text = @"不重复";
                        break;
                    case 1:
                        self.scheduleRepeatLabel.text = @"每日重复";
                        break;
                    case 2:
                        self.scheduleRepeatLabel.text = @"每周重复";
                        break;
                    case 3:
                        self.scheduleRepeatLabel.text = @"每月重复";
                        break;
                    case 4:
                        self.scheduleRepeatLabel.text = @"每年重复";
                        break;
                        
                    default:
                        break;
                }
            });
        };
    }
}

- (void)configureScheduleDetailCell
{
    //日程名称
    self.scheduleTitleLabel.text = self.scheduleModel.scheduleName ;
    
    //日程地址
    self.scheduleAddress.text = self.scheduleModel.scheduleAddress ;
    if (self.scheduleModel.scheduleAddress.length == 0) {
        self.scheduleAddress.text = @"添加位置";
    }
    
    //日程描述
    self.scheduleDescribcLabel.text = self.scheduleModel.scheduleDescribe ;
    CGSize  size = [Tool calculateMessage:self.scheduleModel.scheduleDescribe fontOfSize:12.0 maxWidth:SCREEN_WIDTH - 70 maxHeight:MAXFLOAT];
    self.describeLabelHeight.constant = size.height;
    
    //日程开始时间
    self.scheduleStartTime.text = [Tool stringFromFomate:self.scheduleModel.schedulestartTime formate:@"yyyy-MM-dd HH:mm"] ;
    
    //日程结束时间
    self.scheduleEndtime.text = [Tool stringFromFomate:self.scheduleModel.scheduleEndTime formate:@"yyyy-MM-dd HH:mm"];
    //提醒时间
    self.scheduleRemindTimeLabel.text = [Tool stringFromFomate:self.scheduleModel.scheduleRemindTime formate:@"HH:mm"];
    //日程参与人
    NSArray *followers = [self.scheduleModel.scheduleFollowers allObjects] ;
    NSMutableString *followerName = [NSMutableString new] ;
    for (User *user in followers) {
        [followerName appendFormat:@"%@ " , user.userName];
    }
    self.scheduleFollowers.text = followerName ;
    
    //日程附件
    self.scheduleAnnex.text = [NSString stringWithFormat:@"%d" , (int)[self.scheduleModel.annexs allObjects].count];
   
    //日程重复
    NSInteger repeatType = [self.scheduleModel.schedulerepeat integerValue];
    switch (repeatType) {
        case 0:
            self.scheduleRepeatLabel.text = @"不重复" ;
            break;
        case 1:
            self.scheduleRepeatLabel.text = @"每日重复" ;
            break;
        case 2:
            self.scheduleRepeatLabel.text = @"每周重复" ;
            break;
        case 3:
            self.scheduleRepeatLabel.text = @"每月重复" ;
            break;
        case 4:
            self.scheduleRepeatLabel.text = @"每年重复" ;
            break;
        default:
            break;
    }
}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    switch (result) {
        case MFMailComposeResultSent:
            debugLog(@"MFMailComposeResultSent");
            break;
        case MFMailComposeResultSaved:
            debugLog(@"MFMailComposeResultSaved");
            break;
        case MFMailComposeResultCancelled:
            debugLog(@"MFMailComposeResultCancelled");
            break;
        case MFMailComposeResultFailed:
            debugLog(@"MFMailComposeResultFailed");
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DatePickerViewControllerDelegate
- (void)selectedDate:(NSDate *)date
{
    self.scheduleStartTime.text = [Tool stringFromFomate:date formate:@"yyyy-MM-dd HH:mm"] ;
    self.scheduleModel.schedulestartTime = date ;
    if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
        debugLog(@"modity schedule start time fail");
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //附件
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        PhtotoController *photoCtl = [[PhtotoController alloc]init];
        photoCtl.scheduleModel = _scheduleModel;
        photoCtl.annexUploadCountBlock = ^(NSInteger annexUploadCount){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.scheduleAnnex.text = [NSString stringWithFormat:@"%d" , (int)annexUploadCount];
            });
        };
        [self.navigationController pushViewController: photoCtl animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize  size = [Tool calculateMessage:self.scheduleModel.scheduleDescribe fontOfSize:12.0 maxWidth:SCREEN_WIDTH - 70 maxHeight:MAXFLOAT];
        return size.height + 60 ;
    }
    return 44.0 ;
}
@end
