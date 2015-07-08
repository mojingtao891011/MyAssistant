//
//  AppDelegate.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/18.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "User.h"
#import "CoreDataModelService.h"
#import "Task.h"
#import "Schedule.h"
#import "SVProgressHUD.h"



//#define LOGIN_USERNAME
#ifdef LOGIN_USERNAME
#define test               @"test1"
#define userID              @"10054"
#else
#define test                    @"test2"
#define userID              @"10053"
#endif


@interface AppDelegate ()<UIAlertViewDelegate>
{
    NSTimer  *_heartbeatTimer ;
    NSManagedObjectContext          *_context ;
    
    NSString *_remindContent ;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    _context = [CoreDataStack shareManaged].managedObjectContext ;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendSchedule:) name:NOTE_ADDSCHEDULECOMPLETE object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendTask:) name:NOTE_ADDTASKCOMPLETE object:nil];
    
    [self creatUserTest];
    
    //[self autoLogin];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stopSendHead];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self startSendHead];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CoreDataStack shareManaged] saveContext];
}
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
   
    if (buttonIndex == 1) {
        
        if (![_context save:nil]) {
            debugLog(@"down ok");
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTE_RECEIVE_MESSAGE object:nil];
    }
    else{
        
    }
}
- (void)creatUserTest
{
    
    [[NSUserDefaults standardUserDefaults]setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    User *user = [CoreDataModelService fetchUserByName:[UIDevice currentDevice].name];
    if (user) {
        return ;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSError *error = nil ;
    NSArray *results = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        
        //创建默认任务
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
        User *user = [[User alloc]initWithEntity:entity insertIntoManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
       
        user.userName = [UIDevice currentDevice].name ;
        user.userMobile = @"18682470426";
        user.userMail = @"mojt@lierda.com";
        
        [[CoreDataStack shareManaged].managedObjectContext save:nil];
        
    }

}
#pragma mark - Message
- (void)sendSchedule:(NSNotification*)note
{
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
      Schedule *scheduleModel = note.object ;
    
//    _remindContent = [NSString stringWithFormat:@"您有%@-%@ %@ 的日程" , [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"MM月dd日 HH:mm"], [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"MM月dd日 HH:mm"],scheduleModel.scheduleName ];
    
  
    
    NSString *scheduleName = scheduleModel.scheduleName ;
    NSString *schedulestartTime = [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"yyyy年MM月dd日 HH:mm"] ;
    NSString *scheduleEndTime =  [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"yyyy年MM月dd日 HH:mm"] ;
    
    NSString *scheduleRemindTime = [Tool stringFromFomate:scheduleModel.scheduleRemindTime formate:@"yyyy年MM月dd日 HH:mm"] ;
    
    NSString *scheduleCreateUser = DEVICE_NAME ;
    
    if (!scheduleRemindTime) {
        scheduleRemindTime = @"";
    }
    
    NSString *schedulerepeat = scheduleModel.schedulerepeat.stringValue;
    if (!schedulerepeat) {
        schedulerepeat = @"0";
    }
    
    NSMutableString *scheduleFollowers   = [NSMutableString new];
    for (User *user in [scheduleModel.scheduleFollowers allObjects]) {
        
        [scheduleFollowers appendFormat:@"%@#$" , user.userName];
    }
    
    NSString *scheduleAddress = scheduleModel.scheduleAddress ;
    if (!scheduleAddress) {
        scheduleAddress = @"";
    }
    
    NSString *scheduleCreatDateDay = [Tool stringFromFomate:scheduleModel.scheduleCreatDateDay  formate:DATE_FORMATE];
    
    NSString *scheduleCreatDay = scheduleModel.scheduleCreatDay ;
    
    NSString *scheduleCreatDetailTime = [Tool stringFromFomate:scheduleModel.scheduleCreatDetailTime  formate:@"yyyy-MM-dd HH:mm"];
    
    NSDictionary *dict = @{
                           @"scheduleName":scheduleName,
                           @"schedulestartTime":schedulestartTime,
                           @"scheduleEndTime":scheduleEndTime,
                           @"scheduleRemindTime":scheduleRemindTime,
                           @"schedulerepeat":schedulerepeat,
                           @"scheduleFollowers":scheduleFollowers,
                           @"scheduleAddress":scheduleAddress,
                           @"scheduleCreatDateDay":scheduleCreatDateDay,
                           @"scheduleCreateUser":scheduleCreateUser,
                           @"scheduleCreatDay":scheduleCreatDay,
                           @"scheduleCreatDetailTime":scheduleCreatDetailTime
                           };
    [self uploade:dict];
}
- (void)sendTask:(NSNotification*)note
{
     [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    Task *taskModel = note.object ;
    
    
//    _remindContent = [NSString stringWithFormat:@"您有%@-%@ %@ 的日程" , [Tool stringFromFomate: taskModel.taskStartTime formate:@"yyyy年MM月dd日"], [Tool stringFromFomate:taskModel.taskEndTime formate:@"yyyy年MM月dd"],taskModel.taskName ];
    
    NSString *taskName = taskModel.taskName ;
    NSString *taskStartTime = [Tool stringFromFomate: taskModel.taskStartTime formate:@"yyyy年MM月dd日"] ;
    NSString *taskEndTime = [Tool stringFromFomate:taskModel.taskEndTime formate:@"yyyy年MM月dd"];
    NSString *taskExecutorName = taskModel.executor.userName ;
    NSString *taskCreatUserName  = DEVICE_NAME ;
    
    if (taskExecutorName.length == 0) {
        taskExecutorName = @"";
    }
    
    NSMutableString *taskFollowers   = [NSMutableString new];
    for (User *user in [taskModel.followers allObjects]) {
        
        [taskFollowers appendFormat:@"%@#$" , user.userName];
    }
   
    NSString *taskTag = [NSString stringWithFormat:@"%@" , taskModel.taskTag];
    NSString *taskCreatDay = [Tool stringFromFomate: taskModel.taskTheDate formate:DATE_FORMATE] ;
    
    NSDictionary *taskDict = @{
                               @"taskName" : taskName ,
                               @"taskStartTime" : taskStartTime,
                               @"taskEndTime" : taskEndTime ,
                               @"executor":taskExecutorName,
                               @"followers":taskFollowers,
                               @"taskTag":taskTag,
                               @"taskCreatDateDay":taskCreatDay,
                               @"taskCreatUserName":taskCreatUserName
                               };
    
    
    [self uploade:taskDict];
}
- (void)autoLogin
{
    
    __weak AppDelegate *weakSelf = self ;
    //邮箱登陆时发送：{"publickey":"......","command":"login","user":{"email":"......","passwd":"......"}}
    
    NSDictionary *dict = @{@"publickey":PUBLICKEY,@"command":@"login",@"user":@{@"email":test,@"passwd":@"123456"}};
    
    [[NetworkService sharedClient] startNetworkUrl:loginUrlStr andParmDict:dict andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        
        
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)result ;
            if ([dict[@"result"] isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"privatekey"] forKey:@"privatekey"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"login ok");
                
                //[weakSelf testSendMessage];
                [weakSelf startSendHead];
                
                _isLoginsuccess = YES ;
            }
            else{
                _isLoginsuccess = NO ;
            }
        }
        else{
            _isLoginsuccess = NO ;
        }
        
        
    }andFailBlock:^(NSString *fail){
        
         _isLoginsuccess = NO ;
    }];
}
- (void)uploade:(NSDictionary*)dict
{
    debugLog(@"上传……");
     __weak AppDelegate *weakSelf = self ;
    
    //NSDictionary *dict = @{@"key1":@"v1" , @"key2" : @[@"a1" , @"a2"] , @"key3" : @{@"dict2_key":@"dict2_v"}};
    
    NSError *error ;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"hdshd fail");
         [SVProgressHUD dismiss];
        abort();
       
    }
    
    //上传
    [[NetworkService sharedClient] uploadUrl:uploadUrlStr andFileName:@"testName" andFileData:data andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        
        
        //debugLog(@"%@" , result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)result ;
            if ([dict[@"result"] isEqual:@"success"]) {
                NSInteger typeId = [dict[@"typid"] integerValue];
                if (typeId == 3) {
                    
                    debugLog(@"上传成功……");
                    //上传成功
                    [weakSelf sendMessage:dict[@"url"]];
                }
               
            }
            else{
                
                
            }
        }
        
    }andFailBlock:^(NSString *fail) {
        debugLog(@"network %@" , fail);
         [SVProgressHUD dismiss];
       // [_weakSelf updateDataWhenSendCompletion:NO];
        
    }];

    
}
#pragma mark - 发送心态包
- (void)startSendHead
{
    
    if (!_heartbeatTimer ) {
        _heartbeatTimer =[NSTimer scheduledTimerWithTimeInterval:5  target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
    }
}
- (void)stopSendHead
{
    if ([_heartbeatTimer isValid]) {
        [_heartbeatTimer invalidate];
        _heartbeatTimer = nil ;
    }
}
- (void)sendHeartbeat
{
    __weak AppDelegate *weakself = self ;
    //{"privatekey":"......","command":"sync","result":"success","msglist":["...","...","..."]}。
    
    
    NSDictionary *dict = @{@"privatekey":PRIVATEKEY,@"command":@"sync"};
    
    [[NetworkService sharedClient]startNetworkUrl:sendInfoUrlStr andParmDict:dict andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        
        
        if ([Tool isSuccess:@"success" command:@"sync" result:result]) {
            NSDictionary *dict = (NSDictionary*)result ;
            NSArray *msglist = dict[@"msglist"];
            if (msglist.count != 0) {
                
                for (NSDictionary *dicts in msglist) {
                    [weakself fetchMassega:dicts[@"msgid"]];
                }
                
            }
        }
    }andFailBlock:^(NSString *fail){
        
    }];
    
}
- (void)fetchMassega:(NSString*)msgid
{
     debugLog(@"接收到消息");
    
     //[SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    __weak AppDelegate *weakself = self ;
    
    NSDictionary *dict = @{@"privatekey":PRIVATEKEY,@"command":@"getmsg" , @"msgid": msgid};
    
    [[NetworkService sharedClient]startNetworkUrl:@"/imessage.php" andParmDict:dict andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        //{"privatekey":"......","command":"getmsg","result":"success","message":{"msgid":"......","time":"......","sender":"......","typid":"......","content":"......"}}
        debugLog(@"%@" , result);
        
       
        
        if ([Tool isSuccess:@"success" command:@"getmsg" result:result]) {
            NSDictionary *dict = (NSDictionary*)result ;
            NSDictionary *messageDict = dict[@"message"];
            //语音
            if ([messageDict[@"typid"] isEqualToString:@"3"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    

                    [weakself download:messageDict[@"content"] time:messageDict[@"time"]];

                });
            }
            
        }
    }andFailBlock:^(NSString *fail){
        debugLog(@"fetch fail");
        //[SVProgressHUD dismiss];
    }];
}

- (void)sendMessage:(NSString*)content
{
    //{"privatekey":"......","command":"putmsg","messages":{"recver":"......","typid":"...","content":"......"}}
    
    debugLog(@"发送url……");
    
    NSDictionary *dict = @{@"privatekey":PRIVATEKEY,@"command":@"putmsg",@"message":@{@"recver":userID,@"typid":@"3",@"content":content}};
    
    
    [[NetworkService sharedClient]startNetworkUrl:sendInfoUrlStr andParmDict:dict andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        
//        debugLog(@"%@" , result);
        
         [SVProgressHUD dismiss];
        
        if ([Tool isSuccess:@"success" command:@"putmsg" result:result]) {
            
             debugLog(@"发送消息成功");
        }
       
    }andFailBlock:^(NSString *fail){
        
         [SVProgressHUD dismiss];
    }];
    
}

- (void)download:(NSString*)url time:(NSString*)time
{
    
     debugLog(@"下载消息");
    __weak AppDelegate *weakSelf = self ;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *respone , NSData *data , NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
        
            
            if (!error) {
                NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [weakSelf dictToModel:dict];
            }
            else{
                
            }
            
        });
    }];
    
}

- (void)dictToModel:(NSDictionary*)dict
{
    
     debugLog(@"装入数据模型");
    
    NSString *titleStr ;
    //说明是Task
    
    for (NSString *dictKey in [dict allKeys]) {
        
        if ([dictKey isEqualToString:@"taskName"]) {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:_context];
            Task *taskModel = [[Task alloc]initWithEntity:entity insertIntoManagedObjectContext:_context];
            
            taskModel.taskName = dict[@"taskName"];
            taskModel.taskStartTime = [Tool dateFromFomate:dict[@"taskStartTime"] formate:@"yyyy年MM月dd日"];
            taskModel.taskEndTime = [Tool dateFromFomate:dict[@"taskEndTime"] formate:@"yyyy年MM月dd"];
            taskModel.taskTag = [NSNumber numberWithInteger:[dict[@"taskTag"] integerValue]];
            taskModel.taskTheDate = [Tool dateFromFomate:dict[@"taskCreatDateDay"] formate:DATE_FORMATE];
            
            
            User *user = [CoreDataModelService fetchUserByName:dict[@"executor"]];
            if (user) {
                taskModel.executor = user ;
            }
            else{
                NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_context];
                User *executor = [[User alloc]initWithEntity:entity1 insertIntoManagedObjectContext:_context];
                executor.userName = dict[@"executor"];
                taskModel.executor = executor ;
            }
            
            NSString *follwersStr = dict[@"followers"];//#$
            NSArray *arr = [follwersStr componentsSeparatedByString:@"#$"];
            NSMutableArray *f_arr = [NSMutableArray new];
            for (NSString *f_name in arr) {
                if ([Tool removeFirstSpace:f_name].length == 0) {
                    continue ;
                }
                User *user1 = [CoreDataModelService fetchUserByName:f_name];
                if (user1) {
                    [f_arr addObject:user1];
                   
                }
                else{
                    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_context];
                    User *follwers = [[User alloc]initWithEntity:entity2 insertIntoManagedObjectContext:_context];
                    follwers.userName = f_name;
                    [f_arr addObject:follwers];
                }
                
            }
            taskModel.followers = [NSSet setWithArray:f_arr];
            
            
            titleStr = dict[@"taskCreatUserName"];
            
            _remindContent = [NSString stringWithFormat:@"发起任务 %@-%@ %@ " , [Tool stringFromFomate: taskModel.taskStartTime formate:@"yyyy年MM月dd日"], [Tool stringFromFomate:taskModel.taskEndTime formate:@"yyyy年MM月dd"],taskModel.taskName ];
            

            
//            if (![_context save:nil]) {
//                debugLog(@"receive ok");
//            }
           
        }
        
        if ([dictKey isEqualToString:@"scheduleName"]) {
            
            NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:_context];
            Schedule *scheduleModel = [[Schedule alloc]initWithEntity:entity1 insertIntoManagedObjectContext:_context];
            
            
            scheduleModel.scheduleName = dict[@"scheduleName"];
            scheduleModel.schedulestartTime = [Tool dateFromFomate:dict[@"schedulestartTime"] formate:@"yyyy年MM月dd日 HH:mm"];
            scheduleModel.scheduleEndTime = [Tool dateFromFomate:dict[@"scheduleEndTime"] formate:@"yyyy年MM月dd日 HH:mm"];
            scheduleModel.scheduleRemindTime = [Tool dateFromFomate:dict[@"scheduleRemindTime"] formate:@"yyyy年MM月dd日 HH:mm"];
            scheduleModel.schedulerepeat = [NSNumber numberWithInteger:[dict[@"schedulerepeat"] integerValue]];
            scheduleModel.scheduleAddress = dict[@"scheduleAddress"];
            scheduleModel.scheduleCreatDateDay = [Tool dateFromFomate:dict[@"scheduleCreatDateDay"] formate:DATE_FORMATE];
            scheduleModel.scheduleCreatDay = dict[@"scheduleCreatDay"];
            scheduleModel.scheduleCreatDetailTime = [Tool dateFromFomate:dict[@"scheduleCreatDetailTime"] formate:@"yyyy-MM-dd HH:mm"];
            
            NSString *followersStr = dict[@"scheduleFollowers"];
            NSArray *arr = [followersStr componentsSeparatedByString:@"#$"];
            NSMutableArray *followersArr = [NSMutableArray new];
            for (NSString *str in arr) {
                if ([Tool removeFirstSpace:str].length == 0) {
                    continue;
                }
                User *user = [CoreDataModelService fetchUserByName:str];
                if (user) {
                    continue ;
                }
                
                NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_context];
                User *user1 = [[User alloc]initWithEntity:entity2 insertIntoManagedObjectContext:_context];
                user1.userName = str ;
                [followersArr addObject:user1];
                
            }
            scheduleModel.scheduleFollowers = [NSSet setWithArray:followersArr];
            
            titleStr = dict[@"scheduleCreateUser"];
            
             _remindContent = [NSString stringWithFormat:@"发起日程%@-%@ %@ " , [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"MM月dd日 HH:mm"], [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"MM月dd日 HH:mm"],scheduleModel.scheduleName ];
            
//            if (![_context save:nil]) {
//                debugLog(@"down schedule fail");
//            }
        }
    }
    
    
    debugLog(@"刷新界面");
    
    [[[UIAlertView alloc]initWithTitle:titleStr message:_remindContent delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"查 看", nil]show ];
    
   // [SVProgressHUD dismiss];
    
    
    
    
}
@end
