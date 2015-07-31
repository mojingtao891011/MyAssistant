//
//  Comment.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/30.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule, Task, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentContent;
@property (nonatomic, retain) NSDate * commentContentTime;
@property (nonatomic, retain) Schedule *schedule;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) User *user;

@end
