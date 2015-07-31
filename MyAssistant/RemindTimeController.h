//
//  RemindTimeController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/15.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"
#import "Remind.h"

@interface RemindTimeController : BaseController

@property (nonatomic , retain)NSDate *scheduleStartTime ;
@property (nonatomic , assign)NSInteger  subRemindNumber ;
@property (nonatomic , copy)void(^remindDateBlock)(NSDate *date , NSString *scheduleRemindType , NSInteger  subRemindNumber);

@end
