//
//  CoreDataModelService.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User , Project ;
@interface CoreDataModelService : NSObject

+ (User*)fetchUserByName:(NSString *)userName ;

+ (Project*)fetchProjectByName:(NSString*)projectName ;

+(NSArray*)fetchAllUser ;

+ (NSArray*)fetchAllTask ;

+ (NSArray*)fetchAllSchedule ;

+(BOOL)deleteTaskByTaskCreatTime:(NSDate*)taskCreatTime;
+(BOOL)deleteScheduleByScheduleCreatDetailTime:(NSDate*)scheduleCreatDetailTime;

@end
