//
//  TestAddScheduleController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@class Schedule ;
@interface AddScheduleController : BaseController

@property (nonatomic , retain)Schedule      *scheduleModel ;
@property (nonatomic , assign)BOOL              isCreatSchedule ;

@end
