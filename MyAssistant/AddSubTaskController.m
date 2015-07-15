//
//  SubTaskController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddSubTaskController.h"
#import "User.h"
#import "FriendListController.h"

@interface AddSubTaskController ()

@property (weak, nonatomic) IBOutlet UITextField *subTextTF;
@property (weak, nonatomic) IBOutlet UILabel *executorLabel;
@property (weak, nonatomic) IBOutlet UILabel *setTimeLabel;

@property (nonatomic , retain)NSManagedObjectContext  *context ;

@end

@implementation AddSubTaskController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    self.isHidenRightButton = NO ;
    self.rightButtonImageName = @"save";
    
    
    if (self.subTask) {
        
        self.subTextTF.text = self.subTask.subTaskName ;
        
        //判断是否是今年 、今天
        NSString *startString = nil ;
        NSString *endString = nil ;
        NSDate  *startTime = self.subTask.subTaskStartTime;
        NSDate *endTime = self.subTask.subTaskEndTime ;
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
        self.setTimeLabel.text = [NSString stringWithFormat:@"%@-%@" , startString , endString];
        
        self.executorLabel.text = self.subTask.executor.userName ;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (SubTask*)subTask
{
    if (_subTask) {
        return _subTask ;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubTask" inManagedObjectContext:self.context];
    SubTask *task = [[SubTask alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
    self.subTask = task ;
    
    //默认开始、结束时间
    self.subTask.subTaskStartTime = CUR_SELECTEDDATE ;
    self.subTask.subTaskEndTime = [NSDate dateWithTimeInterval:24*60*60 sinceDate:CUR_SELECTEDDATE];
    
    return _subTask ;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WS(weakself);
    
//    if ([segue.identifier isEqualToString:@"addSubTaskCtlPushDatePickSegue"]) {
//        
//        DatePickerViewController *dataPickerCtl = segue.destinationViewController;
//        dataPickerCtl.typeInt = 0 ;
//        dataPickerCtl.startTime = self.subTask.subTaskStartTime ;
//        dataPickerCtl.endTime = self.subTask.subTaskEndTime;
//        dataPickerCtl.scheuleDateBlock = ^(NSDate *startTime , NSDate *endTime){
//            
//            //保存时间
//            weakself.subTask.subTaskStartTime = startTime ;
//            weakself.subTask.subTaskEndTime = endTime ;
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //判断是否是今年 、今天
//                NSString *startString = nil ;
//                NSString *endString = nil ;
//                //开始时间
//                if ([startTime isThisYear]) {
//                    startString = [Tool stringFromFomate:startTime formate:@"MM月dd日"];
//                }
//                else{
//                    startString = [Tool stringFromFomate:startTime formate:@"yyyy年MM月dd日"] ;
//                }
//                
//                if ([startTime isToday]) {
//                    startString = @"今天";
//                }
//                //结束时间
//                if ([endTime isThisYear]) {
//                    endString = [Tool stringFromFomate:endTime formate:@"MM月dd日"] ;
//                }
//                else{
//                    endString = [Tool stringFromFomate:endTime formate:@"yyyy年MM月dd日"] ;
//                }
//                
//                //开始时间、结束时间都是今天(今天00:15-0630)
//                if ([startTime isToday] &&[endTime isToday] ) {
//                    startString  = [NSString stringWithFormat:@"今天%@",[Tool stringFromFomate:startTime formate:@"HH:mm"]];
//                    endString = [Tool stringFromFomate:endTime formate:@"HH:mm"] ;
//                }
//                
//                
//                weakself.setTimeLabel.text = [NSString stringWithFormat:@"%@-%@" , startString , endString];
//                
//            });
//            
//            
//        };
//       
//        
//    }
     if ([segue.identifier isEqualToString:@"pushFriendListControllerSegue"]){
        
        /*
         
         
         ExecutorController *executor = segue.destinationViewController;
         
         executor.executorUser = weakself.subTask.executor ;
         
         executor.selectExecutorBlock = ^(User *user){
         
         //保存执行者
         weakself.subTask.executor = user ;
         
         dispatch_async(dispatch_get_main_queue(), ^{
         
         weakself.executorLabel.text = user.userName ;
         
         });
         
         };
         
    */
        
        FriendListController *friendListCtl = segue.destinationViewController;
        friendListCtl.isExecutor = YES ;
        if (self.subTask.executor) {
            friendListCtl.colletionDataSources = [NSMutableArray arrayWithObject:self.subTask.executor];
        }
        friendListCtl.selectedFriendBlock = ^(NSMutableArray *userArr){
            //保存执行者
            User *user = [userArr firstObject];
            weakself.subTask.executor = user ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakself.executorLabel.text = user.userName ;
                
            });
        };
    }
}
#pragma mark - SaveSubTask

- (void)rightAction{
    
    if ([Tool removeFirstSpace:_subTextTF.text].length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"任务名称不能留空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确 定", nil]show ];
        return;
    }
    
    self.subTask.subTaskName = _subTextTF.text ;
    
    if (self.saveSubTaskBlock) {
        self.saveSubTaskBlock(self.subTask);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
