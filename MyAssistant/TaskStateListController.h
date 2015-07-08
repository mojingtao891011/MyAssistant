//
//  TaskListController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"

@protocol TaskStateListControllerDelegate <NSObject>

- (void)selectedTaskState:(NSString*)taskState ;

@end

@interface TaskStateListController : BaseTableController

@property (nonatomic , assign)id<TaskStateListControllerDelegate> taskListControllerDelegate ;

@property (nonatomic , copy)NSString *curTaskState;

@end
