//
//  CoreDataModelService.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "CoreDataModelService.h"
#import "User.h"
#import "CoreDataStack.h"
#import "Task.h"

@implementation CoreDataModelService

+ (User*)fetchUserByName:(NSString *)userName
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@" , userName];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creatTaskUser.userName = %@" , DEVICE_NAME];
    [fetchRequest setPredicate:predicate];
    
   // [cars filteredArrayUsingPredicate: predicate];
    
    return nil ;
}
+(BOOL)deleteTaskByTaskCreatTime:(NSDate*)taskCreatTime
{
    //实例化查询
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Task"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"taskCreatTime",taskCreatTime];
    //    request.predicate=[NSPredicate predicateWithFormat:@"name=%@",name];
    NSError *error;
    Task *taskModel;
    //进行查询
    NSArray *results=[[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
    }else{
        taskModel=[results firstObject];
    }
    
    [[CoreDataStack shareManaged].managedObjectContext deleteObject:taskModel];

    return  [[CoreDataStack shareManaged].managedObjectContext  save:nil];
}
+(BOOL)deleteScheduleByScheduleCreatDetailTime:(NSDate*)scheduleCreatTime
{
    //实例化查询
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Schedule"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"scheduleCreatTime",scheduleCreatTime];
    //    request.predicate=[NSPredicate predicateWithFormat:@"name=%@",name];
    NSError *error;
    Task *taskModel;
    //进行查询
    NSArray *results=[[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
    }else{
        taskModel=[results firstObject];
    }
    
    [[CoreDataStack shareManaged].managedObjectContext deleteObject:taskModel];
    
    return  [[CoreDataStack shareManaged].managedObjectContext  save:nil];
}
+ (SubRemind*)fetchSubRemindBySubRemindNumber:(NSInteger)number  schedule:(Schedule*)schedule
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubRemind"];
    request.predicate = [NSPredicate predicateWithFormat:@"subRemindNumber ==%@ && schedule == %@" , [NSNumber numberWithInteger:number] , schedule];
    NSError *error;
    SubRemind *subRemind = nil ;
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
