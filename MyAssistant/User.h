//
//  User.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/30.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Annex, Comment, Schedule, SubTask, Task, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSData * userImg;
@property (nonatomic, retain) NSString * userMail;
@property (nonatomic, retain) NSString * userMobile;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *annexs;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *creatShchedules;
@property (nonatomic, retain) NSSet *creatTasks;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *schedulesFollowers;
@property (nonatomic, retain) NSSet *subTaskExecutors;
@property (nonatomic, retain) NSSet *taskExecutors;
@property (nonatomic, retain) NSSet *taskFollowers;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAnnexsObject:(Annex *)value;
- (void)removeAnnexsObject:(Annex *)value;
- (void)addAnnexs:(NSSet *)values;
- (void)removeAnnexs:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addCreatShchedulesObject:(Schedule *)value;
- (void)removeCreatShchedulesObject:(Schedule *)value;
- (void)addCreatShchedules:(NSSet *)values;
- (void)removeCreatShchedules:(NSSet *)values;

- (void)addCreatTasksObject:(Task *)value;
- (void)removeCreatTasksObject:(Task *)value;
- (void)addCreatTasks:(NSSet *)values;
- (void)removeCreatTasks:(NSSet *)values;

- (void)addFriendsObject:(User *)value;
- (void)removeFriendsObject:(User *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addSchedulesFollowersObject:(Schedule *)value;
- (void)removeSchedulesFollowersObject:(Schedule *)value;
- (void)addSchedulesFollowers:(NSSet *)values;
- (void)removeSchedulesFollowers:(NSSet *)values;

- (void)addSubTaskExecutorsObject:(SubTask *)value;
- (void)removeSubTaskExecutorsObject:(SubTask *)value;
- (void)addSubTaskExecutors:(NSSet *)values;
- (void)removeSubTaskExecutors:(NSSet *)values;

- (void)addTaskExecutorsObject:(Task *)value;
- (void)removeTaskExecutorsObject:(Task *)value;
- (void)addTaskExecutors:(NSSet *)values;
- (void)removeTaskExecutors:(NSSet *)values;

- (void)addTaskFollowersObject:(Task *)value;
- (void)removeTaskFollowersObject:(Task *)value;
- (void)addTaskFollowers:(NSSet *)values;
- (void)removeTaskFollowers:(NSSet *)values;

@end
