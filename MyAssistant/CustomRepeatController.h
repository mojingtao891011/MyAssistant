//
//  CustomController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@interface CustomRepeatController : BaseController

@property (nonatomic , retain)NSDate *scheduleRemindTime;

@property (nonatomic , copy)void(^CustomRepeatBlock)(NSInteger frequencyInt , NSInteger repeatInt , NSMutableArray *dateArr);

@end
