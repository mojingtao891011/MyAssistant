//
//  SubTask.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/7.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task, User;

@interface SubTask : NSManagedObject

@property (nonatomic, retain) NSDate * subTaskEndTime;
@property (nonatomic, retain) NSString * subTaskName;
@property (nonatomic, retain) NSDate * subTaskStartTime;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) User *executor;

@end
