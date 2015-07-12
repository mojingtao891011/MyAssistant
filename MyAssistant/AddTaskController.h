//
//  TestAddTaskController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@class Task ;
@interface AddTaskController : BaseController

@property (nonatomic , retain)Task  *taskModel;
@property (nonatomic ,assign)BOOL isCreatTask ;

@end
