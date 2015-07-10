//
//  SubRemindController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/9.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"
#import "SubRemind.h"

typedef enum :NSInteger
{
    NoRemind = 0,
    everyDayRemind = 1,
    everyWeekRemind = 2,
    everyMonthRemind = 3,
    everyYearRemind = 4,
}RemindType;

@interface SubRemindController : BaseTableController

@property(nonatomic , retain)SubRemind      *subRemindModel;
@property (nonatomic , copy)void(^subRemindBlock)(NSDate *remindTime , NSInteger remindType , BOOL isCreatSubRemind);
@property (nonatomic , copy)void(^deleteRemindBlock)();

@end
