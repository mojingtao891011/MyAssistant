//
//  Friends.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/27.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friends : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * nick;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * curScheduleCount;
@property (nonatomic, retain) NSNumber * curCompleteScheduleCount;
@property (nonatomic, retain) NSNumber * curTaskCount;
@property (nonatomic, retain) NSNumber * curCompleteTaskCount;

@end
