//
//  EditScheduleController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/30.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"
#import "Schedule.h"

@interface EditScheduleController : BaseTableController

@property (nonatomic , retain)Schedule      *scheduleModel ;
@property (nonatomic , copy)void(^modityScheduleNameBlock)();

@end
