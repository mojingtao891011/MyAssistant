//
//  Remind.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/31.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface Remind : NSManagedObject

@property (nonatomic, retain) NSString * remindType;
@property (nonatomic, retain) NSNumber * remindIndex;
@property (nonatomic, retain) NSDate * remindTime;
@property (nonatomic, retain) Schedule *schedule;

@end
