//
//  Example8ViewController.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15/5/28.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "BaseController.h"
#import "Task.h"
#import "Schedule.h"


@interface PhtotoController : BaseController

@property (nonatomic , retain)Task  *taskModel ;
@property (nonatomic , retain)Schedule  *scheduleModel ;
@property (nonatomic , copy)void(^annexUploadCountBlock)(NSInteger annexUploadCount);

@end
