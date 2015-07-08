//
//  CoreDataStack.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/20.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject


@property (nonatomic , retain)NSManagedObjectContext                *managedObjectContext  ;
@property (nonatomic , retain)NSPersistentStoreCoordinator              *persistentStoreCoordinator ;
@property (nonatomic , retain)NSManagedObjectModel                    *managedObjectModel  ;

+ (instancetype)shareManaged ;
- (void)saveContext ;

@end
