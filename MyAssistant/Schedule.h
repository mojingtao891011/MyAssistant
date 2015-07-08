//
//  Schedule.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/6.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Annex, Comment, SubRemind, User;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSString * scheduleAddress;
@property (nonatomic, retain) NSDate * scheduleCreatDateDay;
@property (nonatomic, retain) NSString * scheduleCreatDay;
@property (nonatomic, retain) NSDate * scheduleCreatDetailTime;
@property (nonatomic, retain) NSString * scheduleDescribe;
@property (nonatomic, retain) NSDate * scheduleEndTime;
@property (nonatomic, retain) NSString * scheduleName;
@property (nonatomic, retain) NSNumber * schedulerepeat;
@property (nonatomic, retain) NSDate * schedulestartTime;
@property (nonatomic, retain) NSDate * scheduleRemindTime;
@property (nonatomic, retain) NSSet *annexs;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *creatScheduleUser;
@property (nonatomic, retain) NSSet *scheduleFollowers;
@property (nonatomic, retain) NSSet *subReminds;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addAnnexsObject:(Annex *)value;
- (void)removeAnnexsObject:(Annex *)value;
- (void)addAnnexs:(NSSet *)values;
- (void)removeAnnexs:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addScheduleFollowersObject:(User *)value;
- (void)removeScheduleFollowersObject:(User *)value;
- (void)addScheduleFollowers:(NSSet *)values;
- (void)removeScheduleFollowers:(NSSet *)values;

- (void)addSubRemindsObject:(SubRemind *)value;
- (void)removeSubRemindsObject:(SubRemind *)value;
- (void)addSubReminds:(NSSet *)values;
- (void)removeSubReminds:(NSSet *)values;

@end
