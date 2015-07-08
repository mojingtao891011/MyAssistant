//
//  SubTaskController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"
#import "SubTask.h"

@interface AddSubTaskController : BaseTableController

@property (nonatomic , retain)SubTask  *subTask ;
@property (nonatomic , copy)void(^saveSubTaskBlock)(SubTask *subTaskModel);



@end
