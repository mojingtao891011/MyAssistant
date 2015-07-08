//
//  CoreDataStack.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/20.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "CoreDataStack.h"

@implementation CoreDataStack

+ (instancetype)shareManaged
{
    static CoreDataStack *_shareManaged = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^(){
        
        _shareManaged = [[CoreDataStack alloc]init];
        
    });
    
    return _shareManaged ;
}

@synthesize managedObjectContext = _managedObjectContext ;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator ;
@synthesize managedObjectModel = _managedObjectModel ;

- (NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext ;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSLog(@"NSPersistentStoreCoordinator fail");
        abort();
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc]init];
    _managedObjectContext.persistentStoreCoordinator = coordinator ;
    
    return _managedObjectContext ;
}
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator ;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirectoryUrl = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeUrl = [documentDirectoryUrl URLByAppendingPathComponent:@"MyAssistant.sqlite"];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES) , NSInferMappingModelAutomaticallyOption:@(YES)};
    NSError *error  = nil ;
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
    if (error) {
        NSLog(@"store fail");
        abort() ;
    }
    
    return _persistentStoreCoordinator ;
}
- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel ;
    }
    
    NSURL *modelUrl = [[NSBundle mainBundle]URLForResource:@"MyAssistant" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelUrl];
    
    return _managedObjectModel ;
}

- (void)saveContext
{
    NSError *error = nil ;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"save fail");
        abort() ;
    }
}
@end
