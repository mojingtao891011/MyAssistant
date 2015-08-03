//
//  CoreDataModelService.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "CoreDataModelService.h"
#import "CoreDataStack.h"
#import "User.h"
#import "Task.h"
#import "Schedule.h"

@implementation CoreDataModelService

+ (User*)fetchUserByName:(NSString *)userID
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@" , userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil ;
    NSArray *results = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ByNameFetchUserFail");
        abort();
    }
    
    if (results.count == 0) {
        return nil ;
    }
    
    User *user = [results firstObject];
    
    return user;
    
}
+(NSArray*)fetchAllUser
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    
    NSError *error = nil ;
    NSArray *results = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ByNameFetchUserFail");
        abort();
    }
    
    if (results.count == 0) {
        return nil ;
    }

    return results;

}
+ (NSArray*)fetchAllTask
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskName != nil"];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil ;
    NSArray *results = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ByNameFetchUserFail");
        abort();
    }
    
    if (results.count == 0) {
        return nil ;
    }
    
    return results;
}
+ (NSArray*)fetchAllSchedule
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Schedule"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleName != nil"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil ;
    NSArray *results = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ByNameFetchUserFail");
        abort();
    }
    
    if (results.count == 0) {
        return nil ;
    }
    
    return results;

}

+(NSArray*)fetchTaskByDate:(NSDate*)date
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
//    NSArray *curUserCreatAllTasks = [curUser.creatTasks allObjects];
//    NSSortDescriptor *sortTaskTag = [NSSortDescriptor sortDescriptorWithKey:@"taskTag" ascending:NO];
//    NSSortDescriptor *sortTaskEndTime = [NSSortDescriptor sortDescriptorWithKey:@"taskEndTime" ascending:NO];
//    NSSortDescriptor *sortTaskCreatTime = [NSSortDescriptor sortDescriptorWithKey:@"taskCreatTime" ascending:NO];
//    self.myCreatTasks = [curUserCreatAllTasks sortedArrayUsingDescriptors:@[sortTaskTag , sortTaskEndTime , sortTaskCreatTime]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creatTaskUser.userID = %@" , USER_ID];
    [fetchRequest setPredicate:predicate];
    
   // [cars filteredArrayUsingPredicate: predicate];
    
    return nil ;
}

+ (BOOL)deleteTaskByTaskModel:(Task*)task
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    NSError *error;
    NSArray *tasks = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error == nil) {
        if ([tasks containsObject:task]) {
            [[CoreDataStack shareManaged].managedObjectContext deleteObject:task];
        }
    }
    
    return  [[CoreDataStack shareManaged].managedObjectContext  save:nil];
}
+ (BOOL)deleteScheduleByScheduleModel:(Schedule*)schedule
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Schedule"];
    NSError *error;
    NSArray *schedules = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error == nil) {
        if ([schedules containsObject:schedule]) {
            [[CoreDataStack shareManaged].managedObjectContext deleteObject:schedule];
        }
    }
    return  [[CoreDataStack shareManaged].managedObjectContext  save:nil];
}
+ (Remind*)fetchSubRemindBySubRemindNumber:(NSInteger)number  schedule:(Schedule*)schedule
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Remind"];
    request.predicate = [NSPredicate predicateWithFormat:@"remindIndex ==%@ && schedule == %@" , [NSNumber numberWithInteger:number] , schedule];
    NSError *error;
    Remind *subRemind = nil ;
    //进行查询
    NSArray *results=[[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
        abort() ;
    }else{
        subRemind =[results firstObject];
    }

    return subRemind ;
}
@end
