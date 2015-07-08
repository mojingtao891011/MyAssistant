//
//  EditController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"

@class Task ;
@interface EditTaskNameController : BaseTableController

@property (nonatomic , retain)Task              *myTask ;
@property (nonatomic , copy)void(^EditTaskCompleteBlock)(Task *editTask);

@end
