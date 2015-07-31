//
//  Task.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/30.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Annex, Comment, SubTask, User;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * taskCreatTime;
@property (nonatomic, retain) NSString * taskDescribe;
@property (nonatomic, retain) NSDate * taskEndTime;
@property (nonatomic, retain) NSNumber * taskIsFininsh;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSNumber * taskProgress;
@property (nonatomic, retain) NSDate * taskStartTime;
@property (nonatomic, retain) NSNumber * taskTag;
@property (nonatomic, retain) NSDate * taskTheDate;
@property (nonatomic, retain) NSSet *annexs;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *creatTaskUser;
@property (nonatomic, retain) User *executor;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *subTasks;

@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addAnnexsObject:(Annex *)value;
- (void)removeAnnexsObject:(Annex *)value;
- (void)addAnnexs:(NSSet *)values;
- (void)removeAnnexs:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addSubTasksObject:(SubTask *)value;
- (void)removeSubTasksObject:(SubTask *)value;
- (void)addSubTasks:(NSSet *)values;
- (void)removeSubTasks:(NSSet *)values;

@end
