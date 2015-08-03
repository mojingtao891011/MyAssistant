//
//  MessageViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/18.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MessageController.h"
#import "TabBarViewController.h"
#import "NetworkService.h"

@interface MessageController ()<UITableViewDataSource , UITableViewDelegate>


@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBarButtonItem];
    

//[self test];
}

- (void)test
{
    /*
     @property (nonatomic, retain) NSNumber * userID;
     @property (nonatomic, retain) NSData * userImg;
     @property (nonatomic, retain) NSString * userMail;
     @property (nonatomic, retain) NSString * userMobile;
     @property (nonatomic, retain) NSString * userName;
     
     @property (nonatomic, retain) NSSet *annexs;
     @property (nonatomic, retain) NSSet *comments;
     @property (nonatomic, retain) User *creatTaskUser;
     @property (nonatomic, retain) User *executor;
     @property (nonatomic, retain) NSSet *followers;
     @property (nonatomic, retain) NSSet *subTasks;
     {
     “privatekey":"......",
     “command":"107",
     “msglist”:[{“ taskCreatTime = ..”,”taskDescribe = ”},]
     }
*/
    NSMutableArray *annexs = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 1; i++) {
        NSDictionary *annex = @{
                                @"annexFileData":[NSDate date],
                                @"annexType":[NSNumber numberWithInt:1],
                                @"annexUploadTime":[NSDate date],
                                @"...":@"..."
                                };
        [annexs addObject:annex];
    }
    
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 1; i++) {
        NSDictionary *comment = @{
                                   @"commentContent":@"评论内容",
                                   @"commentContentTime":[NSDate date],
                                   @"...":@"..."
                                   };
        [comments addObject:comment];
    }
    
    
    NSDictionary *creatTaskUser = @{
                                    @"userName":@"userName",
                                    @"userId":@"10001",
                                    @"userImg":@"www.upload.com"
                                    };
    
    
    NSDictionary *executor = @{
                               @"userName":@"executor",
                               @"userId":@"10001",
                               @"userImg":@"www.upload.com"
                               };
    
    NSMutableArray *followers = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 1; i++) {
        NSDictionary *follower = @{
                                   @"userName":@"follower",
                                   @"userId":@"10001",
                                   @"userImg":@"www.upload.com"
                                   };
        [followers addObject:follower];
    }
   
    
    NSMutableArray *subTasks = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 1; i++) {
         NSDictionary *subTask = @{
                                    @"subTaskEndTime":[NSDate date],
                                    @"subTaskName":@"subTaskName",
                                    @"subTaskStartTime":@"subTaskStartTime"
                                    };
        [subTasks addObject:subTask];
    }
    
    NSDictionary *parmDict = @{
                               @"taskCreatTime": [NSDate date],
                               @"taskDescribe":@"描述",
                               @"taskStartTime":[NSDate date],
                               @"taskEndTime":[NSDate date],
                               @"taskName":@"任务名",
                               @"taskTag":[NSNumber numberWithInteger:1],
                               @"executor":executor,
                                @"followers":followers,
                               
                               @"taskIsFininsh":[NSNumber numberWithBool:YES],
                               @"taskProgress":[NSNumber numberWithFloat:40.0],
                               @"annexs":annexs,
                               @"comments":comments,
                               @"creatTaskUser":creatTaskUser,
                               @"subTasks":subTasks
                               };
    
    
    NSArray *parmarr = @[parmDict];
    
    
    
    NSDictionary *dict = @{
                           @"privatekey":@"......",
                           @"command":@"107",
                           @"magList":parmarr
                           };
    
    NSLog(@"%@" , dict);
   
    //[[NetworkService sharedClient]startNetworkUrl:nil andParmDict:dict andNetworkServiceDelegate:nil andCompletionBlock:nil andFailBlock:nil];
}

#pragma mark - DefaultUI
- (void)addLeftBarButtonItem
{
    //leftBarButtonItem
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 35)];
    leftButton.tag = 2 ;
    [leftButton setImage:[UIImage imageNamed:@"icon_self"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton ;

}
#pragma mark - Action
- (void)leftBarButtonItemAction:(UIButton*)sender
{
    
    TabBarViewController *taBarCtl = (TabBarViewController*)self.tabBarController ;
    [taBarCtl selectleViewController:sender];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    return cell ;
}
@end
