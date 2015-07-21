//
//  SubRemind.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface SubRemind : NSManagedObject

@property (nonatomic, retain) NSDate * subRemindTime;
@property (nonatomic, retain) NSString * subRemindType;
@property (nonatomic, retain) NSNumber * subRemindNumber;
@property (nonatomic, retain) Schedule *schedule;

@end
