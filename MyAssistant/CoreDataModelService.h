//
//  CoreDataModelService.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Remind.h"

@class User ,Task,Schedule;
@interface CoreDataModelService : NSObject

+ (User*)fetchUserByName:(NSString *)userID ;

+(NSArray*)fetchAllUser ;

+ (NSArray*)fetchAllTask ;

+ (NSArray*)fetchAllSchedule ;

+ (BOOL)deleteTaskByTaskModel:(Task*)task ;
+ (BOOL)deleteScheduleByScheduleModel:(Schedule*)schedule ;


+ (Remind*)fetchSubRemindBySubRemindNumber:(NSInteger)number  schedule:(Schedule*)schedule ;

@end
