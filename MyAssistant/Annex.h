//
//  Annex.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule, Task, User;

@interface Annex : NSManagedObject

@property (nonatomic, retain) NSData * annexFileData;
@property (nonatomic, retain) id annexOriginImage;
@property (nonatomic, retain) id annexThumbImage;
@property (nonatomic, retain) NSNumber * annexType;
@property (nonatomic, retain) NSDate * annexUploadTime;
@property (nonatomic, retain) Schedule *schedule;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) User *user;

@end
